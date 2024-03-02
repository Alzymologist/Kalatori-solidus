require 'httparty'

class Kalatori::AddressController < ApplicationController
  include Spree::Core::ControllerHelpers::Store 
  include Spree::Core::ControllerHelpers::Order
  
  SHOP_ID = 1

  def generate
    # Getting current shopping cart price from session
    @order = current_order(create_order_if_necessary: true)
    
    response = HTTParty.get("http://localhost:4010/order/#{SHOP_ID}/price/#{@order.id}")
    render json: response
  end
end
