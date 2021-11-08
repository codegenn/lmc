require "httparty"
require 'uri'

module VNPay
  VNP_HOST = "https://sandbox.vnpayment.vn".freeze

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

    def create_url(params)
      uri = "paymentv2/vpcpay.html"
      url = "#{VNP_HOST}/#{uri}?#{params}"
      return url
    end

    def auth_signature(body, secret_key)
      Digest::SHA256.hexdigest(secret_key + body)
    end

    private

    def pay_post(uri, payload = {}, signature)
      # headers = {
      #   "X-Airpay-ClientId" => config.client_id,
      #   "X-Airpay-Req-H" => signature
      # }
      url = "#{VNP_HOST}/#{uri}?#{params}"
      HTTParty.post(url, {headers: headers, body: payload.to_json})
    end
  end
end
