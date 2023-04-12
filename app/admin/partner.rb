ActiveAdmin.register Partner do
  permit_params :alt, :url, :partner_image

  index do
    column :alt
    column :url
    actions
  end

  form do |f|
    f.inputs "Partner Details" do
      f.input :alt
      f.input :url
      f.input :partner_image, as: :file, hint: f.object.try(:partner_image) ? cl_image_tag(f.object.try(:partner_image), width: 200) : image_tag(f.object.partner_image, width: 200)
    end
    f.actions
  end

  show do |product|
    attributes_table do
      row :alt
      row :url
      
      row :partner_image do |ad|
        if ad.partner_image.present?
          cl_image_tag ad.partner_image, :width => 50
        else
          image_tag ad.partner_image, :width => 50
        end
      end
    end
  end

  controller do
    before_action :upload_partner_image, only: [:create, :update]

    def upload_partner_image
      
      image_attrs = params[:partner][:product_images_attributes]
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
