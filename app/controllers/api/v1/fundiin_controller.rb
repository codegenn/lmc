module Api
  module V1
    class FundiinController < ApiController
      before_action :check_order

      def update_tags
        return render json: template_json(0, "Không Thành Công") unless check_shop_id
        order = Order.find_by_id(@order_id)
        order.status = params["tags"].last
        if order.save
          render json: template_json(1, "Thành Công")
        else
          render json: template_json(0, "Không Thành Công")
        end
      end

      def update_payment
        return render json: template_json(0, "Không Thành Công") unless check_shop_id
        order = Order.find_by_id(@order_id)
        binding.pry
        order.payment_status = params["payment_status"]
        if order.save
          render json: template_json(1, "Thành Công")
        else
          render json: template_json(0, "Không Thành Công")
        end
      end

      def order_detail
        return render json: template_json(0, "Không Thành Công") unless check_shop_id

        @order = Order.find_by_id(@order_id)
        return render json: template_json(0, "Không Thành Công") unless @order.payment_method.include?("FUNDIIN")

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

      def check_shop_id
        return params["shop_id"].present? && params["shop_id"] == ENV["FUNDIIN_SHOP_ID"]
      end
    end
  end
end
