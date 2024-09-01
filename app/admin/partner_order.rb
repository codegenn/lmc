ActiveAdmin.register PartnerOrder do
  permit_params :user_id, :stock_item, :total_products, :inventory, :fee, :total_sell, 
                partner_managers_attributes: [:id, :start_time, :end_time, :quantity_entered, :product_sold, :revenue, :note, :_destroy,
                partner_managers_details_attributes: [:id, :size, :stock, :sold_product, :_destroy]]

  index do
    id_column
    
    column :user do |partner_order|
      partner_user = PartnerUser.find_by(id: partner_order.user_id)
      partner_user ? partner_user.email : "User not found"
    end
    column :start_time
    column :end_time
    column 'Thời gian thanh toán', :time_pay_partner
    column 'Phí trả LMcation (25-35%)' do |partner_order|
      "#{number_with_delimiter(partner_order.fee.to_i, delimiter: '.')} %"
    end
    column 'Tổng sản phẩm đã bán', :total_sell
    column 'Tổng doanh thu' do |partner_order|
      "#{number_with_delimiter(partner_order.revenue.to_i, delimiter: '.')} VND"
    end
    column 'Thanh toán cho đối tác' do |partner_order|
      "#{number_with_delimiter(partner_order.time_pay.to_i, delimiter: '.')} VND"
    end

    column :note
    actions
  end

  show do
    attributes_table do
      row :user do |partner_order|
        PartnerUser.find_by(id: partner_order.user_id)&.email || "User not found"
      end
      row :start_time
      row :end_time
      row 'Thời gian thanh toán' do |po|
        po.time_pay_partner
      end
      row 'Phí trả LMcation (25-35%)' do |partner_order|
        "#{number_with_delimiter(partner_order.fee.to_i, delimiter: '.')} %"
      end
      row 'Tổng sản phẩm đã bán' do |po|
        po.total_sell
      end
      row 'Tổng doanh thu' do |partner_order|
        "#{number_with_delimiter(partner_order.revenue.to_i, delimiter: '.')} VND"
      end
      row 'Thanh toán cho đối tác' do |partner_order|
        "#{number_with_delimiter(partner_order.time_pay.to_i, delimiter: '.')} VND"
      end
      row :note
      
      row "Partner Managers" do |partner_order|
        table_for partner_order.partner_managers do
          column :product_id do |partner_order|
            Stock.find_by(id: partner_order.product_id).product_code || "Product not found"
          end
          column "Số lượng nhập", :quantity_entered
          column "Số lượng bán", :product_sold
          column "Tồn kho", :inventory
          column 'Doanh thu' do |partner_order|
            "#{number_with_delimiter(partner_order.revenue.to_i, delimiter: '.')} VND"
          end
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :user_id, as: :select, collection: PartnerUser.all.map { |user| [user.email, user.id] }
      f.input :start_time, as: :datetime_picker
      f.input :end_time, as: :datetime_picker
      f.input :time_pay_partner, as: :datetime_picker, label: 'Thời gian thanh toán'
      f.input :fee, input_html: { class: 'total_fee' }, label: 'Phí trả LMcation (25-35%)'
      f.input :total_sell, input_html: { disabled: true, style: 'color: gray; background-color: lightgray;', class: 'total_sell' }, label: 'Tổng sản phẩm đã bán'
      f.input :revenue, input_html: { readonly: true, style: 'color: gray; background-color: lightgray;',class: 'total_revenue' }, label: 'Tổng doanh thu (VND)'
      f.input :time_pay, label: "Thanh toán cho đối tác (VND)", input_html: { readonly: true, class: 'total_pay_for_partner', style: 'color: gray; background-color: lightgray;' }
      f.input :note
    end
  
    f.has_many :partner_managers, allow_destroy: true, new_record: true do |detail|
      detail.input :product_id, 
      as: :select, 
      collection: Stock.distinct.order(product_code: :ASC).map { |stock|
        [stock.product_code, stock.id] 
      },
      label: "Product", 
      input_html: { class: 'product_select' }
      detail.input :quantity_entered, label: "Số lượng nhập", input_html: { class: 'quantity_entered' }
      detail.input :product_sold, label: "Số lượng bán", input_html: { class: 'product_sold' }
      detail.input :inventory, label: "Tồn kho", input_html: { readonly: true, class: 'inventory' }
      detail.input :revenue, label: "Doanh thu (VND)", input_html: { readonly: true, class: 'revenue' }
    end
  
    f.actions
  end

  controller do
    def new
      @partner_order = PartnerOrder.new
      @partner_order.partner_managers.build
      super
    end
    
    def create
      @partner_order = PartnerOrder.new(permitted_params[:partner_order])
      product = Stock.find_by(product_code: params[:partner_order][:stock_item])&.product
      super
    end
    
    def update
      @partner_order = PartnerOrder.find(params[:id])
      product = Stock.find_by(product_code: params[:partner_order][:stock_item])&.product
      super
    end
    
    def permitted_params
      params.permit(partner_order: [:user_id, :end_time, :start_time, :time_pay_partner, :revenue, :total_sell, :fee, :time_pay, :note,
                                    partner_managers_attributes: [:id, :product_id, :revenue , :inventory, :quantity_entered, :product_sold, :pay_for_partner, :note, :_destroy, 
                                    partner_managers_details_attributes: [:id, :size, :stock, :quantity_sold, :quantity_in ,:_destroy]]])
    end
  end
end
