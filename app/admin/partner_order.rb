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
    column :time_pay_partner
    actions
  end

  show do
    attributes_table do
      row :user do |partner_order|
        PartnerUser.find_by(id: partner_order.user_id)&.email || "User not found"
      end
      row :start_time
      row :end_time
      row :time_pay_partner
      
      row "Partner Managers" do |partner_order|
        table_for partner_order.partner_managers do
          column :product do |partner_order|
            Product.find_by(id: partner_order.product_id)&.title || "Product not found"
          end
          column "Quantity Entered", :quantity_entered
          column "Product Sold", :product_sold
          column :revenue
          column :fee
          column "Pay For Partner", :pay_for_partner
          column :note
          
          column "Partner Manager Details" do |manager|
            table_for manager.partner_managers_details do
              column :size
              column "Quantity In", :quantity_in
              column "Quantity Sold", :quantity_sold
            end
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
      f.input :time_pay_partner, as: :datetime_picker
    end
  
    f.has_many :partner_managers, allow_destroy: true, new_record: true do |detail|
      detail.input :product_id, as: :select, collection: Product.active.limit(2).map { |product| [product.title, product.id] }, label: "Product", input_html: { class: 'product_select' }
      detail.input :quantity_entered, label: "Sản phẩm nhập", input_html: { class: 'quantity_entered' }
      detail.input :product_sold, label: "Sản phẩm đã bán", input_html: { class: 'product_sold' }
      detail.input :revenue, label: "Doanh thu", input_html: { readonly: true, class: 'revenue' }
      detail.input :fee, label: "Phí", input_html: { class: 'fee' }
      detail.input :pay_for_partner, label: "Thanh toán cho đối tác", input_html: { readonly: true, class: 'pay_for_partner' }
      detail.input :note, label: "Ghi chú"
  
      detail.has_many :partner_managers_details, allow_destroy: true, new_record: true, class: 'auto_mapping' do |pm_detail|
        pm_detail.input :size, label: "Size"
        pm_detail.input :quantity_in, label: "Số lượng nhập"
        pm_detail.input :quantity_sold, label: "Sản phẩm đã bán"
      end
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
      params.permit(partner_order: [:user_id, :end_time, :start_time, :time_pay_partner,
                                    partner_managers_attributes: [:id, :product_id,:revenue , :fee, :quantity_entered, :product_sold, :revenue, :pay_for_partner, :note, :_destroy, 
                                    partner_managers_details_attributes: [:id, :size, :stock, :quantity_sold, :quantity_in ,:_destroy]]])
    end
  end
end
