Spree::Core::Engine.add_routes do
  # Add your extension routes here
  namespace :admin do   
    resource :general_settings do
      collection do
        post :abandoned_cart
      end
    end
  end
end
