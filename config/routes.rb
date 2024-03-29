# frozen_string_literal: true

Spree::Core::Engine.routes.draw do
  namespace :kalatori do
    post 'address/generate', to: SolidusKalatori::AddressController.action(:generate)
    post 'address/check', to: SolidusKalatori::AddressController.action(:check)
    post 'blockchain_status', to: SolidusKalatori::AddressController.action(:blockchain_status)
  end
end
