module Api
  module V1
    class SppController < ApiController
      # before_action :authenticate_spp
      before_action :check_reference_id

      def noti_transaction_status
        return render json: template_json(0, "Không Thành Công") unless merchant_spp
        order = Order.find_by_id(@order_id)
        order.status = params["payment_status"]
        if params["amount"].to_i == order.grand_total.to_i && order.save
          render json: template_json(1, "Thành Công")
        else
          render json: template_json(0, "Không Thành Công")
        end
      end

      private

      def template_json(code, message)
        {
          "code": code,
          "message": message
        }
      end

      def check_reference_id
        @order_id = params["reference_id"]
        return render json: template_json(0, "Không Thành Công") unless @order_id.present?

        @order_id
      end

      def merchant_spp
        return params["merchant_ext_id"].present? && params["merchant_ext_id"].include?(ENV["SPP_MERCHANT_EXT_ID"]) &&
          params["store_ext_id"].present? && params["store_ext_id"].include?(ENV["SPP_STORE_EXT_ID"])
      end
    end
  end
end
