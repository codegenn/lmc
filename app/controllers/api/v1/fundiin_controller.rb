module Api
  module V1
    class FundiinController < ApiController
      before_action :check_order

      def update_tags
        order = Order.find_by_id(@order_id)
        order.status = params["tags"].last
        if order.save
          render json: template_json(1, "Thành Công")
        else
          render json: template_json(0, "Không Thành Công")
        end
      end

      def update_payment
        order = Order.find_by_id(@order_id)
        order.payment_status = params["payment_status"]
        if order.save
          render json: template_json(1, "Thành Công")
        else
          render json: template_json(0, "Không Thành Công")
        end
      end

      def order_detail
        @order = Order.find_by_id(@order_id)

        return render json: template_json(0, "Không Thành Công") unless @order.present?
      end

      private

      def template_json(code, message)
        {
          "code": code,
          "message": message
        }
      end

      def check_order
        @order_id = params["order_id"]
        return render json: template_json(0, "Không Thành Công") unless @order_id.present?

        @order_id
      end
    end
  end
end
