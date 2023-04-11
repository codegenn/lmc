ActiveAdmin.register MemberAd do

  permit_params :name, :role, :description, :status, :avatar

  index do
    selectable_column
    id_column
    column :name
    column :role
    column :description
    column :avatar
    column :status
    column :updated_at
    column :created_at
    actions
  end

  filter :name
  filter :role
  filter :status
  filter :updated_at
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :role
      f.input :description
      f.input :avatar
      f.input :status
    end
    f.actions
  end

  controller do
    def show 
      MemberAd.all
    end

    def create 
      @member_ads = MemberAd.new(permitted_params[:member_ad])

      if @member_ads.save 
        redirect_to admin_member_ads_path, notice: "User updated successfully."
      else
        redirect_to admin_member_ads_path, notice: @member_ads.errors.full_messages.to_sentence
      end
    end

    def update 
      params[:member_ad].update(permitted_params[:member_ad])
      redirect_to admin_member_ads_path, notice: "User updated successfully."
    end

    def destroy 
      params[:member_ad].destroy!
      redirect_to admin_member_ads_path, notice: "User delete successfully."
    end
  end
end
