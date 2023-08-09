json.code 1
json.message "Thành Công"
json.order_id @order.id
json.recipient_phone @order.phone
json.recipient_name @order.first_name + " " + @order.last_name
json.shipping_address @order.address + " " + @order.district + " " + @order.city
json.total_price_product_items @order.grand_total
json.created_at @order.created_at
json.payment_gateway "Fundiin"

json.product_items do
  json.array!(@order.line_items) do |line_item|
    product = line_item.stock.product
    json.id line_item.id
    json.product_id product.id
    json.product_name product.title
    json.quantity line_item.quantity
    json.total_price_original line_item.price
    json.total_price_promotion 0
    json.total_price_other 0
  end
end
