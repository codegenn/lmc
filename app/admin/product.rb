ActiveAdmin.register Product do

  permit_params :title, :description, :short_description, :image_url, :price, product_images_attributes: [:id, :_destroy, :url]

  form do |f|
    f.inputs "Book Details" do
      f.input :title
      f.input :short_description
      f.input :description
      f.input :price
      f.has_many :product_images, heading: false, allow_destroy: true do |image_form|
        image_form.input :url, as: :file
      end
    end
    f.actions
  end

  show do |product|
    attributes_table do
      row :title
      row :short_description
      row :description
      row :price
      attributes_table_for product.product_images do
        row :product_image do |ad|
          cl_image_tag ad.url, :width => 400
        end
      end
    end
    active_admin_comments
  end

  controller do
    before_action :upload_product_image, only: [:create, :update]

    def upload_product_image
      image_attrs = params[:product][:product_images_attributes]
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
