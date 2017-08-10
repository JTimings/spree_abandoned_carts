module Spree
  Order.class_eval do

    include Spree::BaseHelper #for before_cutoff

    scope :abandoned,
      -> { limit_time = Time.zone.now - Spree::Config.abandoned_after_minutes.minutes

           incomplete.
           where('email IS NOT NULL').
           where("#{quoted_table_name}.item_total > 0").
           where("#{quoted_table_name}.updated_at < ?", limit_time) }

    scope :abandon_not_notified,
      -> { abandoned.where(abandoned_cart_email_sent_at: nil) }

    def abandoned_cart_actions
      # if package... do the same

      # remove line items past cutoff (or sold out)
      remove_invalid_line_items
      # send abandoned cart email if cart not empty
      if line_items.present? 
        Spree::AbandonedCartMailer.abandoned_cart_email(self).deliver if user.receive_abandoned
        touch(:abandoned_cart_email_sent_at) # even if user doesn't want reminders so order doesn't keep getting picked up as abandoned (pretty inefficient!! but had problems with joining orders and user tables...) 
      else
        # empty order if no line items -> want item_total=0 in this case else these orders will keep getting picked up as abandoned
        self.empty!
      end
    end

    def last_for_user?
      Order.where(email: email).where('id > ?', id).none?
    end

    private

      def remove_invalid_line_items
        line_items.each do |line_item|
          case line_item.delivery_time
          when "11am-12pm","12-1pm"
            type = 'lunch'
          when "5-6pm","6-7pm",""
            type = 'dinner'
          else
            type = 'dinner'
          end
          if ( line_item_sold_out?(line_item) || !before_cutoff(Time.zone.parse(line_item.delivery_date), type) )
            variant = Spree::Variant.find(line_item.variant_id)
            self.contents.remove(variant, line_item.quantity, nil, line_item.delivery_date, line_item.delivery_time)
            self.ensure_updated_shipments
          end
        end
      end

      def line_item_sold_out?(line_item)
        # efficiently get total number of items sold on particular day
        items_sold = Spree::LineItem.joins(:order).where(spree_orders: {state: ["complete","resumed"]}).where(delivery_date: line_item.delivery_date, variant_id: line_item.variant_id).to_a.sum(&:quantity)
        # daily limit fudged as stockitem total on hand
        daily_limit = Spree::StockItem.where("variant_id = ?", line_item.variant_id).to_a.sum(&:count_on_hand)
        return items_sold >= daily_limit 
      end

  end
end
