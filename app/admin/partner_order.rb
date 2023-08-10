ActiveAdmin.register PartnerOrder do
  index do
    id_column
    column :user do |product_code|
      PartnerUser.find(product_code.user_id)&.email
    end
    column :product do |product_code|
      Product.find(Stock.find_by(product_code: product_code.stock_item)&.product_id)&.title
    end
    column :stock_item
    column :total_products
    column :inventory
    column :fee
    column :total_sell
    
    actions
  end

  show do
    attributes_table do
      row :user do |product_code|
        PartnerUser.find(product_code.user_id)&.email
      end
      row :product do |product_code|
        Product.find(Stock.find_by(product_code: product_code.stock_item)&.product_id)&.title
      end
      row :stock_item
      row :total_products
      row :inventory
      row :fee
      row :total_sell
    end
  end

  form do |f|
    inputs do
      input :stock_item, as: :select, collection: Stock.where(product_id: Product.active.pluck(:id)).pluck('stocks.product_code')
      input :total_products
      input :inventory
      input :fee
      input :total_sell
      input :user_id, as: :select, collection: PartnerUser.all.map { |user| [user.email, user.id] }
      actions
    end
  end

  controller do
    def new
      @user_id = params[:user_id]
      super
    end

    def create
      @user_id = params[:partner_order][:user_id]
      super
    end

    def permitted_params
      params.permit(partner_order: [:stock_item, :total_products, :fee, :inventory, :user_id, :total_sell])
    end
  end
end
