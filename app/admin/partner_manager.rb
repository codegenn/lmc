ActiveAdmin.register PartnerManager do
  permit_params :partner_order_id, :start_time, :end_time, :product_sold, :revenue, :fee, :pay_for_partner, :note, partner_managers_details_attributes: [:id, :size, :stock, :sold_product, :_destroy]

  before_save do |partner_manager|
    order = PartnerOrder.find_by(id: partner_manager.partner_order_id)
    if order
      stock = Stock.find_by(product_code: order.stock_item)
      product = stock&.product
      if product
        partner_manager.revenue = product.price * partner_manager.product_sold
      end
    end
  end

  index do
    id_column
    column "Mã sản phẩm - Email đối tác", :partner_order_id do |partner_manager|
      order = PartnerOrder.find_by(id: partner_manager.partner_order_id)
      if order
        "#{order.stock_item} - #{order.partner_user&.email}"
      else
        "N/A"
      end
    end
    column "Bắt đầu", sortable: :start_time do |partner_manager|
      partner_manager.start_time.strftime('%Y-%m-%d') if partner_manager.start_time
    end
    column "Kết thúc", sortable: :end_time do |partner_manager|
      partner_manager.end_time.strftime('%Y-%m-%d') if partner_manager.end_time
    end
    column "Giá", :price do |partner_manager|
      order = PartnerOrder.find_by(id: partner_manager.partner_order_id)
      if order
        stock = Stock.find_by(product_code: order.stock_item)
        product = stock&.product
        product&.price
      end
    end
    column "Sản phẩm đã bán", :product_sold
    column "Doanh thu", :revenue
    column "Phí trả LMcation (25-35%)", :fee
    column "Thanh toán cho đối tác", :pay_for_partner
    column "Ghi chú", :note
    actions
  end
  
  show do
    attributes_table do
      row "Mã sản phẩm - Email đối tác" do |partner_manager|
        order = PartnerOrder.find_by(id: partner_manager.partner_order_id)
        if order
          "#{order.stock_item} - #{order.partner_user.email}"
        else
          "N/A"
        end
      end
      row :start_time do
        partner_manager.start_time.strftime('%Y-%m-%d') if partner_manager.start_time
      end
      row :end_time do
        partner_manager.end_time.strftime('%Y-%m-%d') if partner_manager.end_time
      end
      row "Giá" do |partner_manager|
        order = PartnerOrder.find_by(id: partner_manager.partner_order_id)
        if order
          stock = Stock.find_by(product_code: order.stock_item)
          product = stock&.product
          product&.price
        end
      end
      row :product_sold
      row :revenue
      row :fee
      row :pay_for_partner
      row :note
    end
  
    panel "Chi tiết sản phẩm" do
      table_for partner_manager.partner_managers_details do
        column "Mã sản phẩm", :stock do |detail|
          Stock.find(detail.stock).product_code
        end
        column "Size", :stock do |detail|
          Stock.find(detail.stock).size
        end
        column "Sản phẩm đã bán", :sold_product
      end
    end
  end
  

  form do |f|
    f.inputs "Thông tin chi tiết" do
      f.input :partner_order_id, as: :select, 
            collection: PartnerOrder.joins(:partner_user).select('partner_orders.id, partner_orders.stock_item, partner_users.email')
                        .map { |order| ["#{order.stock_item} - #{order.email}", order.id] }, label: "Mã sản phẩm - Email đối tác"
      f.input :start_time, as: :datetime_picker
      f.input :end_time, as: :datetime_picker
      f.input :product_sold, label: "Sản phẩm đã bán"
      f.input :note, label: "Ghi chú"
    end

    f.has_many :partner_managers_details, heading: 'Chi tiết sản phẩm' do |detail|
      detail.input :stock, label: "Mặt hàng trong kho", as: :select, collection: Stock.all.map { |product| [product.product_code, product.id] }
      detail.input :sold_product, label: "Sản phẩm đã bán"
    end

    f.actions
  end

  controller do
    def update
      super do |success, failure|
        success.html { redirect_to admin_partner_manager_path(resource), notice: "Partner Manager was successfully updated." }
      end
    end
  end
end