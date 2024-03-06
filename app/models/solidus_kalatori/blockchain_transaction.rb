class SolidusKalatori::BlockchainTransaction < Spree::PaymentSource
  self.table_name = "solidus_kalatori_blockchain_transactions"

  belongs_to :payment_method, class_name: 'Spree::PaymentMethod'

  # Payment sources respond to a very simple API which tells Solidus what operations can or cannot be performed on
  # the payment source. Solidus will use this information to display/hide certain actions on the backend, or to control
  # the order processing flow:

  #   `#actions``: returns an array of actions that can generally be performed on payments with this payment source.
  #   `capture`, `void` and `credit` are standard supported actions, but you can also have custom actions here, as long as
  #   `Spree::Payment` responds to them.
  #   `#can_<action>?`: for each of the actions returned by `#actions`, Solidus will attempt to call this method to verify
  #   whether that action can be taken on a payment, which will be passed to the method as the only argument. Default
  #   implementations are provided for `capture`, `void` and `credit` which check the payment's state.
  #   `#reusable?`: whether this payment source is reusable (i.e., whether it can be used on future orders as well).
  #   Solidus will use this to determine whether to add the payment source to the user's wallet after the order is
  #   placed, and to determine which sources to show from the user's wallet during the checkout flow.

  def actions
    %w{capture void credit}
  end

  def can_capture?(payment)
    payment.pending? || payment.checkout?
  end

  def auth_token
    blockchain_address
  end

  def can_void?(payment)
    false
  end

  def can_credit?(payment)
    false
  end

  def reusable?
    false
  end
end
