# def token
#   KiotViet.configure do |config|
#       config.client_id = ENV['KIOT_CLIENT_ID']
#       config.client_secret = ENV['KIOT_CLIENT_SECRET']
#   end

#   respon = KiotViet.get_token

#   token = respon["access_token"]

#   return "Bearer ".concat(token)
# end

# # def update_quantity(product, token)
#   repo = KiotViet.get_product(token, "Testapi0007")
#   data = JSON.parse(repo.body)
#   id = data["inventories"].last["productId"]
#   quantity = data["inventories"].last["onHand"]
# #   puts "====================== #{quantity} \n"
# #   if quantity.present?
# #     Stock.transaction do
# #       product.update(quantity: quantity)
# #       product.save
# #     end
# #   end
# # end

# # KiotViet.get_categories(token)
# # KiotViet.get_customers(token)
# # KiotViet.get_products(token)

# # Product.all.each do |p|
# #   s = p&.stocks
# #   s.each do |v|
# #     puts "-------------------- #{v.product_code}\n"
# #     update_quantity(v, token)
# #   end
# # end


# def add_product
#   payload = {
#     "createdDate": "#{Time.now}",
#     "masterCode": "SPC000062",
#     "retailerId": 1217364,
#     "code": "SP000126",
#     "barCode": "",
#     "name": "test api thêm mới hh 2",
#     "fullName": "test api thêm mới hh 2 (test)",
#     "categoryId": 1487618,
#     "categoryName": "Apple",
#     "allowsSale": true,
#     "type": 2,
#     "hasVariants": false,
#     "basePrice": 100000,
#     "weight": 0,
#     "unit": "VND",
#     "conversionValue": 1,
#     "description": "",
#     "modifiedDate": "#{Time.now}",
#     "isActive": true,
#     "inventories": [
#         {
#             "branchId": 31669,
#             "branchName": "Chi nhánh trung tâm",
#             "cost": 300000,
#             "onHand": 2,
#             "reserved": 0,
#             "actualReserved": 0,
#             "minQuantity": 0,
#             "maxQuantity": 99999999,
#             "isActive": true
#         }
#     ]
#   }

#   KiotViet.add_product(payload, token)
# end

# def create_voucher
#   file = '/home/nguyenhongcam/Desktop/job/lmc/config/initializers/test.csv'
#   CSV.open( file, 'w' ) do |writer|
#     (1..500).each do |i|
#       code = SecureRandom.hex(3).upcase
#       Voucher.transaction do
#         a = Voucher.create(
#           code: code,
#           voucher_type: "50 off",
#           active: true,
#           one_time_use: true
#         )
#         writer << [a.code]
#       end
#     end
#   end
# end


# a = (1..2).map do |v|
#   {
#     "a": v,
#     "c": 1
#   }
# end

# require 'csv'    
# def write_csv
#     Voucher.where(voucher_type: "Sale 50%").each do |v|
#       writer << [v.code, v.voucher_type]
#     end
# end


# # rails generate migration add_stock_quantity_to_stocks quantity:integer