ActiveAdmin.register Foundation do

  permit_params :author, :title, :short_description, :content, :image, :category

  form do |f|
    f.inputs "Foundation Details" do
      f.input :author
      f.input :title
      f.input :short_description
      f.input :content
      input :category, :as => :select, collection: %w(inspiration empowerment blog news), include_blank: true, allow_blank: true
      f.input :image, as: :file, hint: cl_image_tag(f.object.try(:image), width: 200)
    end
    f.actions
  end

  show do |foundation|
    attributes_table do
      row :author
      row :title
      row :short_description
      row :content
      row :category
      row :image do
        image_tag foundation.image, class: 'my_image_size', width: 200
      end
    end
    active_admin_comments
  end

  controller do
    before_action :upload_category_image, only: [:create, :update]

    def upload_category_image
      image_attrs = params[:foundation][:image]
      if image_attrs.present?
        Cloudinary::Uploader.upload(image_attrs.path, public_id:  image_attrs.original_filename.slice(0,image_attrs.original_filename.index('.')))
        params[:foundation][:image] = image_attrs.original_filename
      end
    end
  end
end
