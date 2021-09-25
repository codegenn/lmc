namespace :batch do
  desc "TODO"
  task check_transaction_spp: :environment do
    puts("======== start batch =========")
    secret_key = ENV["SPP_SECRET_KEY"]
    client_id = ENV["SPP_CLIENT_ID"]
    ShopeePay.configure do |config|
      config.client_id = client_id
    end
    order_list = Order.where(payment_method: "Shopee pay")
    order_list.each do |order|
      puts("order: #{order.id}")
      order_id = order.id.to_s
      total_amout = order.grand_total*100
      body = {
        "request_id": order_id.to_s,
        "reference_id": order_id.to_s,
        "store_ext_id": ENV["SPP_STORE_EXT_ID"],
        "merchant_ext_id": ENV["SPP_MERCHANT_EXT_ID"],
        "transaction_type":13,
        "amount": total_amout.to_i
      }
      respon = ShopeePay.check_transaction_status(body, Auth.auth_signature(body, secret_key))
      puts("respon: #{respon["debug_msg"]}")
    end
    puts("======== done =========")
  end
end
