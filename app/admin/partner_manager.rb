ActiveAdmin.register PartnerManager do
    permit_params :partner_order_id, :start_time, :end_time, :product_sold, :revenue, :fee, :pay_for_partner, :note, partner_managers_details_attributes: [:id, :size, :stock, :sold_product, :_destroy]
  
    index do
        id_column
        column :partner_order_id
        column "Bắt đầu", sortable: :start_time do |partner_manager|
          partner_manager.start_time.strftime('%Y-%m-%d') if partner_manager.start_time
        end
        column "Kết thúc", sortable: :end_time do |partner_manager|
          partner_manager.end_time.strftime('%Y-%m-%d') if partner_manager.end_time
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
            row :partner_order_id
          row :start_time do
            partner_manager.start_time.strftime('%Y-%m-%d') if partner_manager.start_time
          end
          row :end_time do
            partner_manager.end_time.strftime('%Y-%m-%d') if partner_manager.end_time
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
            column :size
            column "Sản phẩm đã bán", :sold_product
          end
        end
      end
      
  
    form do |f|
      f.inputs "Thông tin chi tiết" do
        f.input :partner_order_id, as: :select, collection: PartnerOrder.all.map { |order| [order.id, order.id] }
        f.input :start_time, as: :datetime_picker
        f.input :end_time, as: :datetime_picker
        f.input :product_sold, label: "Sản phẩm đã bán"
        f.input :revenue, label: "Doanh thu"
        f.input :fee, label: "Phí trả LMcation (25-35%)"
        f.input :pay_for_partner, label: "Thanh toán cho đối tác"
        f.input :note, label: "Ghi chú"
      end
  
      f.has_many :partner_managers_details, heading: 'Chi tiết sản phẩm' do |detail|
        detail.input :stock, label: "Mặt hàng trong kho", as: :select, collection: Stock.all.map { |product| [product.product_code, product.id] }
        detail.input :size
        detail.input :sold_product, label: "Sản phẩm đã bán"
      end
  
      f.actions
    end
  end
  