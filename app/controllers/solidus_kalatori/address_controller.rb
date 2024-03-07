require 'httparty'

class SolidusKalatori::AddressController < ApplicationController
  protect_from_forgery with: :exception

  include Spree::Core::ControllerHelpers::Store 
  include Spree::Core::ControllerHelpers::Order
  
  def blockchain_status
    payment_method = Spree::PaymentMethod.find_by_type(SolidusKalatori::PaymentMethod.to_s)
    backend_url = payment_method.preferences[:backend_url]

    render json: ask_kalatori(backend_url)
  end

  def generate
    # Getting current shopping cart price from session
    @order = current_order

    # Fail if we can't find the order
    render json: { error: "Order not found" }, status: 404 and return unless @order

    payment_method = Spree::PaymentMethod.find_by_type(SolidusKalatori::PaymentMethod.to_s)
    backend_url = payment_method.preferences[:backend_url]

    render json: ask_kalatori(backend_url, price: @order.total, order_id: @order.id)
  end

  def check
    @order = current_order
    render json: { error: "Order not found" }, status: 404 and return unless @order
    
    payment_method = Spree::PaymentMethod.find_by_type(SolidusKalatori::PaymentMethod.to_s)
    payment = @order.payments.find_by(payment_method: payment_method)
    render json: { error: "No payment found" }, status: 404 and return unless payment
    
    backend_url = payment_method.preferences[:backend_url]
    kalatori_response = ask_kalatori(backend_url, order_id: @order.id, price: @order.total)

    if kalatori_response["result"] == "paid"
      # Marking order as paid
      payment.complete! unless payment.completed?

      # Do we actually need this? Checkout controller should do this for us correctly...
      # # Advancing order to the next state
      # @order.next
    end

    render json: kalatori_response
  end

  private
  def ask_kalatori(kalatori_url, price: 0, order_id: 0)
    kalatori_response = HTTParty.get("#{kalatori_url}/order/#{order_id}/price/#{price}").parsed_response
    kalatori_response
  end
end
