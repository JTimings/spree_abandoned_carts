Spree::Admin::GeneralSettingsController.class_eval do

	def abandoned_cart
		# delay jobs this service...
    AbandonedCartService.perform
    flash[:success] = Spree.t(:abandoned_cart_actions_run)

    redirect_to edit_admin_general_settings_path
  end

end