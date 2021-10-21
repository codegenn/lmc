module Api
  module V1
    class VnpayController < ApiController
      def vnpay_ipn
        if checksum_valid!
          permit_params = response_params
          order_object = Order.find_by_id(permit_params["vnp_TxnRef"])
          if order_object
            if order_object.total_price == (permit_params["vnp_Amount"].to_i / 100)
              if order_object.pending?
                if permit_params["vnp_ResponseCode"] == "00"
                  order_object.payment_status = "Pay Success"
                end
                order_object.save!
                code = "00"
                message = "Confirm Success"
              else
                code = "02"
                message = "Order already confirmed"
              end
            else
              code = "04"
              message = "Invalid amount"
            end
          else
            code = "01";
            message = "Order not found"
          end
        else
          code = "97";
          message = "Invalid Checksum"
        end

        logger.info("VNPAY with params: " + permit_params.to_s + ", code: #{code}, message: #{message}")

        render json: { "RspCode": code, "Message": message }
      rescue => e
        logger.error("VNPAY with params: " + permit_params.to_s + ", " + e.message)
        render json: { "RspCode": "99", "Message": "Unknow error" }
      end

      private

      def checksum_valid!
        vnp_secure_hash = params["vnp_SecureHash"]
        data = response_params.to_h.map do |key, value|
          "#{key}=#{value}"
        end.join("&")
    
        secure_hash = Digest::SHA256.hexdigest(ENV["VNP_HASH_SECRET"] + data)
        vnp_secure_hash == secure_hash
      end
    
      def response_params
        params.permit("vnp_Amount", "vnp_BankCode", "vnp_BankTranNo", "vnp_CardType", "vnp_OrderInfo", "vnp_PayDate", "vnp_ResponseCode", "vnp_TmnCode", "vnp_TransactionNo", "vnp_TxnRef")
      end
    end
  end
end
