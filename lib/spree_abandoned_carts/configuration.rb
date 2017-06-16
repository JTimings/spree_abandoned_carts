module SpreeAbandonedCarts
  class Configuration < Spree::Preferences::Configuration
  	# not used, use Spree::Configs instead
    #preference :abandoned_after_minutes, :integer, default: 120 # 2 hours
    #preference :worker_frequency_minutes, :integer, default: 30 # every 30 min
  end
end
