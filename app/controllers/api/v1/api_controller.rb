module Api
  module V1
    class ApiController < ActionController::Base

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
        secret_key = check_device.include?("mobile") ? ENV["SPP_SECRET_KEY_MOBILE"] : ENV["SPP_SECRET_KEY"]
        render json: {error: "unauthorized"}, status: 401 unless Auth.auth_signature(params["spp"], secret_key).include?(airpay_token)
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

      def auth_spp
      end

      def auth
        Auth.decode(token)
      end

      def auth_present?
        !!request.headers.fetch("Authorization", "") && !!request.headers.fetch("MerchantAuthorization", "") && (token_fundiin.include?(ENV["FUNDIIN_PRIVATE_MERCHANT_CODE"]))
      end

      def auth_present_spp?
        !!request.headers.fetch("X-Airpay-ClientId", "") && !!request.headers.fetch("X-Airpay-Req-H", "") && (airpay_client.include?(ENV["SPP_CLIENT_ID"]))
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