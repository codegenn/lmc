module Api
  module V1
    class SppController < ApiController
      before_action :authenticate_spp, only: [:noti_transaction_status]
      before_action :check_reference_id, only: [:noti_transaction_status]

      def check_transaction
        order = Order.find_by_id(@order_id)
        return render json: template_json(2, "") if order.payment_status.nil?
        payment_status = order.payment_status.to_s.split("_")[0].to_i
        data =  if payment_status.to_i == 2
                  "Đang trong quá trình thanh toán"
                elsif payment_status.to_i == 3
                  "Thanh toán thành công!"
                elsif payment_status.to_i == 4
                  "Thanh toán thất bại!"
                end
        render json: template_json(1, data)
      end

      def noti_transaction_status
        Rails.logger.info("merchant_spp: #{merchant_spp}")
        return render json: template_json(0, "Không Thành Công") unless merchant_spp
        order = Order.find_by_id(@order_id)
        Rails.logger.info("order: #{order.grand_total}")
        return render json: template_json(0, "Không Thành Công") if order.nil?
        order.payment_status = "#{@data_respon_spp["transaction_status"]}_#{@data_respon_spp["transaction_type"]}_#{@data_respon_spp["payment_method"]}"
        update_status(order, @data_respon_spp["transaction_status"])
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
        data =  if payment_status.to_i == 2
                  "Transaction processing"
                elsif payment_status.to_i == 3
                  "Transaction successful"
                elsif payment_status.to_i == 4
                  "Transaction failed"
                end
        order.status = data
      end
    end
  end
end
