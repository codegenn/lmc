module Api
  module V1
    class ApiController < ActionController::Base
      before_action :body_spp

      def logged_in?
        !!current_user
      end

      def current_user
        if auth_present?
          user = AdminUser.find_by_email(auth["user"])
          if user
            @current_user ||= user
          end
        end
      end

      def authenticate_spp
        @data_respon_spp = JSON.parse @data_respon_spp
        secret_key = @data_respon_spp["payment_method"] == 16 ? ENV["SPP_SECRET_KEY_MOBILE"] : ENV["SPP_SECRET_KEY"]
        signature_lmc = Auth.auth_signature(@data_respon_spp, secret_key).gsub("=\n", "=")
        signature_spp = airpay_token.gsub("=\n", "=")
        Rails.logger.info("key_spp: #{signature_spp}")
        Rails.logger.info("signature_lmc: #{signature_lmc}")
        render json: {error: "unauthorized"}, status: 401 unless signature_lmc.include?(signature_spp) && auth_present_spp?
      end

      def authenticate
        render json: {error: "unauthorized"}, status: 401 unless logged_in?
      end

      private

      def airpay_client
        request.headers["X-Airpay-ClientId"]
      end

      def airpay_token
        request.headers["X-Airpay-Req-H"]
      end

      def token
        request.headers["MerchantAuthorization"]
      end

      def token_fundiin
        request.headers["Authorization"]
      end

      def auth
        Auth.decode(token)
      end

      def body_spp
        @data_respon_spp = request.body.read
        @data_respon_spp
      end

      def auth_present?
        !!request.headers.fetch("Authorization", "") && !!request.headers.fetch("MerchantAuthorization", "") && (token_fundiin.include?(ENV["FUNDIIN_PRIVATE_MERCHANT_CODE"]))
      end

      def auth_present_spp?
        lmc_client = @data_respon_spp["payment_method"] == 16 ? ENV["SPP_CLIENT_ID_MOBILE"] : ENV["SPP_CLIENT_ID"]
        !!request.headers.fetch("X-Airpay-ClientId", "") && !!request.headers.fetch("X-Airpay-Req-H", "") && (airpay_client.include?(lmc_client))
      end

      def check_device
        agent = request.user_agent
        return "tablet" if agent =~ /(tablet|ipad)|(android(?!.*mobile))/i
        return "mobile" if agent =~ /Mobile/
        return "desktop"
      end
    end
  end
end