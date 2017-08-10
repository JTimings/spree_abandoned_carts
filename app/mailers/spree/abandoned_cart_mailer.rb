module Spree
  class AbandonedCartMailer < BaseMailer
    def abandoned_cart_email(order)
      if order.email.present?
        @order = order
        @unsubscribe_url = unsubscribe_from_email_settings_url("bag_reminders",@order.user.access_token)
        I18n.with_locale(user_locale(@order)) do
        	name = (order.user.present? && order.user.firstname.present?) ? order.user.firstname+', ' : ""
          subject = name + "#{Spree.t(:abandoned_cart_subject)}"
        	mail(to: order.email, from: from_address, subject: subject)
        end
      end
    end
  end
end