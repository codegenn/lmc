ActiveAdmin.register Product do

  permit_params :is_best_seller, :is_promotion, :is_new_arrival, :image_url, :price, :has_promotion,
                category_ids: [], stocks_attributes: [:id, :_destroy, :size, :color], product_images_attributes: [:id, :_destroy, :url],
                translations_attributes: [:id, :locale, :title, :description, :promotion, :short_description, :_destroy]

  index do
    id_column
    column :title
    column :price
    translation_status
    actions
  end

  form do |f|
    f.inputs "Product Details" do
      f.inputs "Translated fields" do
        f.translated_inputs 'ignored title', switch_locale: false do |t|
          t.input :title
          t.input :short_description
          t.input :description, as: :html_editor
          t.input :promotion
        end
      end

      f.input :price
      f.input :is_best_seller
      f.input :is_promotion
      f.input :is_new_arrival
      f.input :has_promotion
      f.input :categories, as: :check_boxes, collection: Category.all, multiple: true
      f.has_many :product_images, heading: false, allow_destroy: true do |image_form|
        cl_image_tag image_form.object.try(:url), width: 200
        image_form.input :url, as: :file, hint: cl_image_tag(image_form.object.try(:url), width: 200)
      end
      f.has_many :stocks, heading: false, allow_destroy: true do |stocks_form|
        stocks_form.input :size
        stocks_form.input :color, as: :string
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
      row :is_best_seller
      row :is_promotion
      row :is_new_arrival
      attributes_table_for product.product_images do
        row :product_image do |ad|
          cl_image_tag ad.url, :width => 400
        end
      end
      attributes_table_for product.stocks do
        row :size
        row :color
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
