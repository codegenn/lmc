module Api
  module V1
    class SppController < ApiController
      before_action :authenticate_spp
      before_action :check_reference_id

      def noti_transaction_status
        Rails.logger.info("merchant_spp: #{merchant_spp}")
        return render json: template_json(0, "Không Thành Công") unless merchant_spp
        order = Order.find_by_id(@order_id)
        Rails.logger.info("order: #{order.grand_total}")
        return render json: template_json(0, "Không Thành Công") if order.nil?
        order.payment_status = @data_respon_spp["payment_status"]
        update_status(order, @data_respon_spp["payment_status"])
        if @data_respon_spp["amount"].to_i == order.grand_total.to_i*100 && order.save
          Rails.logger.info("amount: #{@data_respon_spp["amount"]}")
          Rails.logger.info("=====save data=====")
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
        @order_id = @data_respon_spp["reference_id"]
        Rails.logger.info("order_id: #{@data_respon_spp["reference_id"]}")
        return render json: template_json(0, "Không Thành Công") unless @order_id.present?

        @order_id
      end

      def merchant_spp
        Rails.logger.info("key_lmcation: #{Auth.auth_signature(@data_respon_spp, ENV["SPP_SECRET_KEY"])}")
        Rails.logger.info("merchant_spp: #{@data_respon_spp["merchant_spp"]}")
        return @data_respon_spp["merchant_ext_id"].present? && @data_respon_spp["merchant_ext_id"].include?(ENV["SPP_MERCHANT_EXT_ID"]) &&
          @data_respon_spp["store_ext_id"].present? && @data_respon_spp["store_ext_id"].include?(ENV["SPP_STORE_EXT_ID"])
      end

      def update_status(order, payment_status)
        data =  if payment_status.to_i == 1
                  "Payment successful"
                elsif payment_status.to_i == 2
                  "Payment not found"
                elsif payment_status.to_i == 3
                  "Payment refunded"
                elsif payment_status.to_i == 5
                  "Payment processing"
                elsif payment_status.to_i == 6
                  "Payment failed"
                end
        order.status = data
      end
    end
  end
end
