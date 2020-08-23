ActiveAdmin.register Order do
  permit_params :first_name, :last_name, :email, :phone, :city, :district, :note, :address, :tracking, :payment_method, :status, :user_id
  show do
    attributes_table do
      row :first_name
      row :last_name
      row :email
      row :phone
      row :city
      row :district
      row :note
      row :address
      row :tracking
      row :payment_method
      row :status
      row :voucher_code
      row :total do  |order|
        number_with_delimiter(order.total_price.to_i, :delimiter => '.')
      end
      row :grand_total do  |order|
        number_with_delimiter(order.grand_total.to_i, :delimiter => '.')
      end
      table_for order.line_items do
        column :title do |line_item|
          link_to line_item.stock.product.title, admin_product_path(line_item.stock.product), target: '_blank'
        end
        column :size do |line_item|
          line_item.stock.size
        end
        column :bottom_stock do |line_item|
          line_item.bottom_stock.try(:size)
        end
        column :color do |line_item|
          line_item.stock.color
        end
        column :quantity do |line_item|
          line_item.quantity
        end
        column :total_price do |line_item|
          number_with_delimiter(line_item.total_price.to_i, :delimiter => '.')
        end
      end
    end
  end
end
