module SpreeAbandonedCarts
  class Configuration < Spree::Preferences::Configuration
    preference :abandoned_after_minutes, :integer, default: 24.hours / 1.minute
    preference :worker_frequency_minutes, :integer, default: 30.minutes
  end
end
