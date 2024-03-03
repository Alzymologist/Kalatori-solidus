class SolidusKalatori::PaymentMethod < Spree::PaymentMethod
  preference :backend_url, :string, default: 'http://localhost:4010'

  def payment_source_class
    SolidusKalatori::BlockchainTransaction
  end

  def supports?(source)
    source.is_a?(payment_source_class)
  end

  def reusable_sources(order)
    return []
  end

  def gateway_class
    SolidusKalatori::Gateway
  end

  def authorize(money, source, options = {})
    gateway.authorize(money, source.auth_token, options)
  end

  def purchase(money, source, options = {})
    gateway.purchase(money, source.auth_token, options)
  end

  def try_void(payment)
    return false if payment.completed?

    void(payment.source.transaction_id)
  end

  def partial_name
    'solidus_kalatori'
  end
end