# frozen_string_literal: true

Spree::Core::Engine.routes.draw do
  namespace :kalatori do
    get 'address/generate', to: SolidusKalatori::AddressController.action(:generate)
  end
  # Add your extension routes here
end
