module Api
  module V1
    class ApiController < ActionController::Base
      before_action :authenticate 

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

      def authenticate
        render json: {error: "unauthorized"}, status: 401 unless logged_in?
      end

      private

      def token
        request.headers["MerchantAuthorization"]
      end

      def token_fundiin
        request.headers["Authorization"]
      end

      def auth
        Auth.decode(token)
      end

      def auth_present?
        !!request.headers.fetch("Authorization", "") && !!request.headers.fetch("MerchantAuthorization", "") && (token_fundiin.include?(ENV["FUNDIIN_PRIVATE_MERCHANT_CODE"]))
      end
    end
  end
end