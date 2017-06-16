class AbandonedCartService
  class << self
    def perform

    	order = Spree::Order.abandon_not_notified.last
    	order.abandoned_cart_actions if order.last_for_user?

      #Spree::Order.abandon_not_notified.each do |order|
      #  next unless order.last_for_user?
      #  order.abandoned_cart_actions
      #end
    end
  end
end