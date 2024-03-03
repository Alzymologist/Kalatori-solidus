module SolidusKalatori
  class Gateway
    attr_reader :backend_url
      
    def initialize(options)
      @backend_url = options.fetch(:backend_url)
    end

    # Payment gateways expose the following API:
    #   #initialize(options): initializes the gateway with the provided options. By default, Solidus will pass the payment method's preferences in here.
    #   #authorize(money, source, options = {}): authorizes a certain amount on the provided payment source.
    #   #capture(money, transaction_id, options = {}): captures a certain amount from a previously authorized transaction.
    #   #purchase(money, source, options = {}): authorizes and captures a certain amount on the provided payment source.
    #   #void(transaction_id, [source,] options = {}): voids a previously authorized transaction, releasing the funds that are on hold. The source parameter is only needed for payment gateways that support payment profiles.
    #   #credit(money, [source,] transaction_id, options = {}): refunds the provided amount on a previously captured transaction. The source parameter is only needed for payment gateways that support payment profiles.
    # All of these methods are expected to return an ActiveMerchant::Billing::Response object containing the result and details of the operation. Payment gateways never raise exceptions when things go wrong: they only return response objects that represent successes or failures, and Solidus handles control flow accordingly.

    def authorize(money, source, options = {})
      response = HTTParty.post("#{backend_url}/authorize", body: {
        money: money,
        source: source,
        options: options
      })
      ActiveMerchant::Billing::Response.new(response.success?, response['message'], response, {})
    end

    def capture(money, transaction_id, options = {})
      response = HTTParty.post("#{backend_url}/capture", body: {
        money: money,
        source: nil,
        options: options
      })
      ActiveMerchant::Billing::Response.new(response.success?, response['message'], response, {})
    end

    def purchase(money, source, options = {})
      self.authorize(money, source, options)
      self.capture(money, source, options)
    end

    def void(transaction_id, source, options = {})
      raise NotImplementedError
    end

    def credit(money, source, transaction_id, options = {})
      raise NotImplementedError
    end

  end
end