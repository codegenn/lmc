ActiveAdmin.register Medium do
    permit_params :alt, :url, :media_image
  
    index do
      column :alt
      column :url
      actions
    end
  
    form do |f|
      f.inputs "Partner Details" do
        f.input :alt
        f.input :url
        f.input :media_image, as: :file, hint: f.object.try(:media_image) ? cl_image_tag(f.object.try(:media_image), width: 200) : image_tag(f.object.media_image, width: 200)
      end
      f.actions
    end
  
    show do |product|
      attributes_table do
        row :alt
        row :url
        
        row :media_image do |ad|
          if ad.media_image.present?
            cl_image_tag ad.media_image, :width => 50
          else
            image_tag ad.media_image, :width => 50
          end
        end
      end
    end
  
    controller do
      before_action :upload_media_image, only: [:create, :update]
  
      def upload_media_image
        image_attrs = params[:medium][:product_images_attributes]
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
  