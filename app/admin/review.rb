ActiveAdmin.register Review do
  permit_params :star_rating, :customer_name, :content, :product_id, :status, review_images_attributes: [:id, :url, :_destroy, :pimage],
                              comments_attributes: [:id, :content, :_destroy]

  form do |f|
    f.inputs do
      f.input :star_rating
      f.input :customer_name
      f.input :content
      f.input :product_id, as: :select, collection: Product.all.order(:title).pluck(:title, :id)
      f.object.review_images.build if f.object.review_images.blank?
      f.has_many :review_images, heading: 'Review Images', allow_destroy: true do |image_form|
        image_form.input :pimage, as: :file, hint: image_form.object.try(:pimage).present? ? image_tag(image_form.object.pimage.url, width: 200) : ''
      end

      f.object.comments.build if f.object.comments.blank?
      f.has_many :comments, heading: 'Reply', allow_destroy: true do |r|
        r.input :content
      end
      f.input :status, as: :boolean, label: 'Active'
    end
    f.actions
  end

  show do |review|
    attributes_table do
      row :star_rating
      row :customer_name
      row :content
      row :product

      # Display review images
      row :review_images do
        ul do
          review.review_images.each do |image|
            li do
              image_tag(image.pimage.url, width: 400)
            end
          end
        end
      end

      # Display comments
      row :comments do
        table_for review.comments do
          column :id
          column :content
        end
      end
    end
  end

  controller do
    before_action :upload_media_image, only: [:create, :update]

    def upload_media_image
      image_attrs = params[:review][:review_images_attributes]
      if image_attrs.present?
        params[:review][:review_images_attributes].each do |key, image_params|
          uploaded_file = image_params[:url]
          if uploaded_file
            Cloudinary::Uploader.upload(uploaded_file.path, public_id: uploaded_file.original_filename.slice(0,uploaded_file.original_filename.index('.')))
            image_attrs[key][:url] = uploaded_file.original_filename
          end
        end
      end
    end
  end
end
