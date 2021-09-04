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
        request.headers["Authorization"]
      end

      def auth
        Auth.decode(token)
      end

      def auth_present?
        !!request.headers.fetch("Authorization", "")
      end
    end
  end
end