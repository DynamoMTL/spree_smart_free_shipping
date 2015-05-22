module SpreeSmartFreeShipping
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_smart_free_shipping'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc

    initializer 'spree.promo.register.promotions.actions' do |app|
      app.config.spree.promotions.actions << Spree::Promotion::Actions::MakeShippingMethodFree
    end

    initializer 'spree.calculators.register.promotion_actions_create_adjustments' do |app|
      app.config.spree.calculators.promotion_actions_create_adjustments << Spree::Calculator::FreeShippingMethod
    end
  end
end
