require 'httparty'

class SolidusKalatori::AddressController < ApplicationController
  include Spree::Core::ControllerHelpers::Store 
  include Spree::Core::ControllerHelpers::Order
  
  cattr_reader :plancks_multiplier

  def initialize
    @@plancks_multiplier ||= fetch_plancks_multiplier
  end

  def generate
    # Getting current shopping cart price from session
    @order = current_order(create_order_if_necessary: true)
    price = (@order.total * plancks_multiplier).to_i
    
    response = HTTParty.get("http://localhost:4010/order/#{@order.id}/price/#{price}")
    render json: response
  end


  private
  # TODO: make sure to ignore errors in the daemon's response
  def fetch_plancks_multiplier
    response = HTTParty.get('http://localhost:4010/order/0/price/0')
    10**response['mul']
  end
end
