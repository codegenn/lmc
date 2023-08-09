require "httparty"
require 'uri'

module Fundiin
  FUNDIIN_HOST = "https://fundiin.vn/api".freeze

  class Config
    attr_accessor :private_code
    attr_accessor :merchant_code
  end

  class << self
    def configure
      yield(config) if block_given?
    end

    def config
      @config ||= Config.new
    end

    def create_booking_sms(payload = {})
      uri = "fundiin/partner/#{config.merchant_code}-send-booking-message"
      pay_post(uri, payload, headers_sms)
    end

    def cancel(body = {})
      uri = "fundiin/partner/#{config.merchant_code}-cancel-order"
      pay_post(uri, payload)
    end

    def order_detail(payload = {})
      uri = "api/#{config.merchant_code}/order_detail"
      pay_post(uri, payload)
    end

    def update_payment(payload = {})
      uri = "api/#{config.merchant_code}/update_payment"
      pay_post(uri, payload)
    end

    def update_tag(payload = {})
      uri = "api/#{config.merchant_code}/update_tags"
      pay_post(uri, payload)
    end

    private

    # Get header data
    def headers
      { 
        "Authorization" => config.private_code,
        "Content-Type" => "application/json"
      }
    end

    def headers_sms
      { 
        "PrivateCode" => config.private_code,
        "Content-Type" => "application/json"
      }
    end

    # POST
    def pay_post(uri, payload = {}, headers = headers)
      url = "#{FUNDIIN_HOST}/#{uri}"
      HTTParty.post(url, {headers: headers, body: payload.to_json})
    end
  end
end
