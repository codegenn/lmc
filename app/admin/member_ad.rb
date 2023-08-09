ActiveAdmin.register MemberAd do
  permit_params :name, :role, :description, :avatar, :status, :number

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
      f.input :number
      f.input :avatar, as: :file, hint: f.object.try(:avatar) ? cl_image_tag(f.object.try(:avatar), width: 200) : image_tag(f.object.avatar, width: 200)
      f.input :status
    end
    f.actions
  end

  controller do
    # def show 
    #   MemberAd.all
    # end

    # def create 
    #   @member_ads = MemberAd.new(params_data)

    #   if @member_ads.save 
    #     redirect_to admin_member_ads_path, notice: "User updated successfully."
    #   else
    #     redirect_to admin_member_ads_path, notice: @member_ads.errors.full_messages.to_sentence
    #   end
    # end

    # def update 
    #   @member = MemberAd.find_by(id: params[:id])
    #   if @member.present?
    #     @member.update(params_data)
    #   end
      
    #   redirect_to admin_member_ads_path, notice: "User updated successfully."
    # end

    # def destroy 
    #   @member = MemberAd.find_by(id: params[:id])
    #   if @member.present?
    #     @member.destroy!
    #   end

    #   redirect_to admin_member_ads_path, notice: "User delete successfully."
    # end

    # private 
    # def params_data
    #   {
    #     :name => params[:member_ad][:name],
    #     :role => params[:member_ad][:role],
    #     :description => params[:member_ad][:description],
    #     :avatar => params[:member_ad][:avatar],
    #     :status => params[:member_ad][:status]
    #   }
    # end

    before_action :upload_avatar, only: [:create, :update]
  
    def upload_avatar
      image_attrs = params[:member_ad][:product_images_attributes]
      if image_attrs.present?
        params[:product][:product_images_attributes].each do |key, image_params|
          uploaded_file = image_params[:url]
          if uploaded_file
            Cloudinary::Uploader.upload(uploaded_file.path, public_id:  uploaded_file.original_filename.slice(0,uploaded_file.original_filename.index('.')))
            image_attrs[key][:url] = uploaded_file.original_filename
          end
        end
      end
    end
  end
end
