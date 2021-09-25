require "httparty"
require 'uri'

module ShopeePay
  SPP_HOST = "https://api.uat.wallet.airpay.vn".freeze

  class Config
    attr_accessor :client_id
  end

  class << self
    def configure
      yield(config) if block_given?
    end

    def config
      @config ||= Config.new
    end

    def create_qr_code(payload = {}, signature)
      uri = "v3/merchant-host/qr/create"
      pay_post(uri, payload, signature)
    end

    def qr_invalidate(payload = {}, signature)
      uri = "v3/merchant-host/qr/invalidate"
      pay_post(uri, payload, signature)
    end

    def check_transaction_status(payload = {}, signature)
      uri = "v3/merchant-host/transaction/check"
      pay_post(uri, payload, signature)
    end

    def create_order(payload = {}, signature)
      uri = "v3/merchant-host/order/create"
      pay_post(uri, payload, signature)
    end

    def create_refund(payload = {}, signature)
      uri = "v3/merchant-host/transaction/refund/create-new"
      pay_post(uri, payload, signature)
    end

    def order_invalidate(payload = {}, signature)
      uri = "v3/merchant-host/order/invalidate"
      pay_post(uri, payload, signature)
    end

    private

    # POST
    def pay_post(uri, payload = {}, signature)
      headers = {
        "X-Airpay-ClientId" => config.client_id,
        "X-Airpay-Req-H" => signature
      }
      url = "#{SPP_HOST}/#{uri}"
      HTTParty.post(url, {headers: headers, body: payload.to_json})
    end
  end
end
