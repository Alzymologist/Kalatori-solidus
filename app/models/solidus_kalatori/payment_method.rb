class SolidusKalatori::PaymentMethod < Spree::PaymentMethod
  preference :backend_url, :string, default: 'http://localhost:4010'
end