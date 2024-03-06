require 'httparty'

class SolidusKalatori::AddressController < ApplicationController
  protect_from_forgery with: :exception

  include Spree::Core::ControllerHelpers::Store 
  include Spree::Core::ControllerHelpers::Order
  
  def generate
    # Getting current shopping cart price from session
    @order = current_order(create_order_if_necessary: true)

    # Fail if we can't find the order
    render json: { error: "Order not found" }, status: 404 and return unless @order

    payment_method = Spree::PaymentMethod.find_by_type(SolidusKalatori::PaymentMethod.to_s)
    backend_url = payment_method.preferences[:backend_url]

    kalatori_response = HTTParty.get("#{backend_url}/order/#{@order.id}/price/#{@order.total}").parsed_response

    payment = @order.payments.find_or_create_by!(payment_method: Spree::PaymentMethod.find_by_type(SolidusKalatori::PaymentMethod.to_s)) do |payment|
      payment.source = SolidusKalatori::BlockchainTransaction.create!(blockchain_address: kalatori_response['pay_account'], payment_method: payment.payment_method)
      payment.amount = @order.total
    end
    
    if kalatori_response["result"] == "paid"
      # Marking order as paid
      payment.complete! unless payment.completed?
    end

    render json: kalatori_response
  end
end
