ActiveAdmin.register Job do
  permit_params :title, :short_description, :content, :avatar

  index do
    column :title
    column :short_description
    column :content
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :short_description
      f.input :content
      f.input :avatar, as: :file, hint: f.object.try(:avatar) ? cl_image_tag(f.object.try(:avatar), width: 200) : image_tag(f.object.avatar, width: 200)
    end
    f.actions
  end

  controller do
    before_action :upload_media_image, only: [:create, :update]

    def upload_media_image
      image_attrs = params[:job][:product_images_attributes]
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
