require "httparty"
require 'uri'

module KiotViet
  KIOT_HOST = "https://id.kiotviet.vn".freeze
  PUB_HOST = "https://public.kiotapi.com".freeze
  SCOPES   = "PublicApi.Access".freeze
  CONTENT_TYPE = "application/x-www-form-urlencoded".freeze
  GRANT_TYPE = "client_credentials".freeze

  class Config
    attr_accessor :client_id
    attr_accessor :client_secret
  end

  class << self
    def configure
      yield(config) if block_given?
    end

    def config
      @config ||= Config.new
    end

    def get_token
      uri = "connect/token"
      payload = {
        client_id: config.client_id,
        client_secret: config.client_secret,
        grant_type: GRANT_TYPE
      }
      pay_post(uri, payload)
    end

    def get_categories(payload = {}, token)
      uri = "categories"
      pay_get(uri, payload, token)
    end

    def get_customers(payload = {}, token)
      uri = "customers"
      pay_get(uri, payload, token)
    end

    def get_products(payload = {}, token)
      uri = "products"
      pay_get(uri, payload, token)
    end

    def get_product(payload = {}, token, product_code)
      uri = "products/code/#{product_code}"
      pay_get(uri, payload, token)
    end

    def add_product(payload = {}, token)
      uri = "products"
      pay_post_add(uri, payload, token)
    end

    def update_product(payload = {}, token, id)
      uri = "products/#{id}"
      pay_put_add(uri, payload, token)
    end

    private

    # POST
    def pay_post(uri, payload = {})
      headers = {
        "Content-Type": CONTENT_TYPE,
        "charset": "utf-8"
      }
      url = "#{KIOT_HOST}/#{uri}"
      HTTParty.post(url, {headers: headers, body: URI.encode_www_form(payload)})
    end

    def pay_get(uri, payload = {}, token)
      headers = {
        "Authorization": token,
        "Retailer": "lmcation"
      }
      url = "#{PUB_HOST}/#{uri}"
      if payload.present?
        HTTParty.get(url, { headers: headers, body: payload.to_json })
      else
        HTTParty.get(url, { headers: headers })
      end
    end

    def pay_post_add(uri, payload = {}, token)
      headers = {
        "Authorization": token,
        "Retailer": "lmcation",
        "Content-Type": "application/json"
      }
      url = "#{PUB_HOST}/#{uri}"
      HTTParty.post(url, { headers: headers, body: payload.to_json })
    end

    def pay_put_add(uri, payload = {}, token)
      headers = {
        "Authorization": token,
        "Retailer": "lmcation",
        "Content-Type": "application/json"
      }
      url = "#{PUB_HOST}/#{uri}"
      HTTParty.put(url, { headers: headers, body: payload.to_json })
    end
  end
end
