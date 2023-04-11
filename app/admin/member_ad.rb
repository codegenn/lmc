ActiveAdmin.register MemberAd do

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
      @member_ads = MemberAd.new(params_data)

      if @member_ads.save 
        redirect_to admin_member_ads_path, notice: "User updated successfully."
      else
        redirect_to admin_member_ads_path, notice: @member_ads.errors.full_messages.to_sentence
      end
    end

    def update 
      @member = MemberAd.find_by(id: params[:id])
      if @member.present?
        @member.update(params_data)
      end
      
      redirect_to admin_member_ads_path, notice: "User updated successfully."
    end

    def destroy 
      @member = MemberAd.find_by(id: params[:id])
      if @member.present?
        @member.destroy!
      end

      redirect_to admin_member_ads_path, notice: "User delete successfully."
    end

    private 
    def params_data
      {
        :name => params[:member_ad][:name],
        :role => params[:member_ad][:role],
        :description => params[:member_ad][:description],
        :avatar => params[:member_ad][:avatar],
        :status => params[:member_ad][:status]
      }
    end
  end
end
