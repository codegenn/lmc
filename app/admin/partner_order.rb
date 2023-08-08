ActiveAdmin.register PartnerOrder do

  form do |f|
    inputs do
      input :product_id, as: :select, collection: Product.all
      input :total_products
      input :fee
      input :inventory
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
      params.permit(partner_order: [:product_id, :total_products, :fee, :inventory, :user_id])
    end
  end
end
