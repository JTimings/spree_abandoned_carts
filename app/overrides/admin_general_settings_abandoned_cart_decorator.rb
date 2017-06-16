Deface::Override.new(:virtual_path => "spree/admin/general_settings/_extra_settings",
                     :name => "admin_general_settings_abandoned_cart_decorator",
                     :insert_top => "div#abandoned",
                     :partial => 'spree/admin/general_settings/abandoned_cart_settings',
                     :disabled => false)