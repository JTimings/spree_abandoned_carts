module Spree
  class AbandonedCartMailer < BaseMailer
    def abandoned_cart_email(order)
      if order.email.present?
        @order = order
        I18n.with_locale(user_locale(@order)) do
        	subject = "#{Spree::Config[:site_name]} - #{Spree.t(:abandoned_cart_subject)}"
        	mail(to: order.email, from: from_address, subject: subject)
        end
      end
    end
  end
end