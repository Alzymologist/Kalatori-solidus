# frozen_string_literal: true

require 'solidus_core'
require 'solidus_support'

module SolidusKalatori
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_kalatori'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'spree.solidus_kalatori.payment_methods', after: 'spree.register.payment_methods' do |app|
      app.reloader.to_prepare do
        app.config.spree.payment_methods << SolidusKalatori::PaymentMethod
      end
    end
  end
end
