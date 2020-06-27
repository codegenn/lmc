ActiveAdmin.register Product do

  permit_params :is_best_seller, :is_promotion, :is_new_arrival, :image_url, :out_of_stock, :promotion_price, :price, :sort_order,
                :has_promotion, :measurement_image_url, :slug_url, category_ids: [],
                stocks_attributes: [:id, :_destroy, :size, :color, :product_code],
                product_images_attributes: [:id, :_destroy, :url], color_images_attributes: [:id, :_destroy, :image_url, :color_name],
                translations_attributes: [:id, :locale, :title, :description, :promotion, :short_description, :measurement_description, :_destroy]

  index do
    id_column
    column :title
    column :price
    column :slug
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
          t.input :measurement_description, as: :html_editor
          t.input :promotion
        end
      end

      f.input :slug_url
      f.input :sort_order
      f.input :price
      f.input :promotion_price
      f.input :is_best_seller
      f.input :is_promotion
      f.input :is_new_arrival
      f.input :has_promotion
      f.input :categories, as: :check_boxes, collection: Category.all, multiple: true
      f.has_many :product_images, heading: false, allow_destroy: true do |image_form|
        cl_image_tag image_form.object.try(:url), width: 200
        image_form.input :url, as: :file, hint: cl_image_tag(image_form.object.try(:url), width: 200)
      end
      f.input :measurement_image_url, as: :file, hint: cl_image_tag(f.object.try(:measurement_image_url), width: 200)
      f.input :out_of_stock, as: :boolean
      f.has_many :stocks, heading: false, allow_destroy: true do |stocks_form|
        stocks_form.input :size
        stocks_form.input :color, as: :string
        stocks_form.input :product_code
      end
      f.has_many :color_images, heading: false, allow_destroy: true do |colors_form|
        colors_form.input :color_name, as: :string
        colors_form.input :image_url, as: :file, hint: cl_image_tag(colors_form.object.try(:image_url), width: 200)
      end
    end
    f.actions
  end

  show do |product|
    attributes_table do
      row :title
      row :slug
      row :slug_url
      row :short_description
      row :measurement_description
      row :description
      row :sort_order
      row :price
      row :promotion_price
      row :is_best_seller
      row :is_promotion
      row :is_new_arrival
      row :measurement_image do
        cl_image_tag product.measurement_image_url, class: 'my_image_size', width: 200
      end
      attributes_table_for product.color_images do
        row :color_name
        row :image_url do |ad|
          cl_image_tag ad.image_url, :width => 50
        end
      end
      attributes_table_for product.product_images do
        row :product_image do |ad|
          cl_image_tag ad.url, :width => 400
        end
      end
      row :out_of_stock
      attributes_table_for product.stocks do
        row :size
        row :color
        row :product_code
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
      image_attrs = params[:product][:color_images_attributes]
      if image_attrs.present?
        params[:product][:color_images_attributes].each do |key, image_params|
          uploaded_file = image_params[:image_url]
          if uploaded_file
            Cloudinary::Uploader.upload(uploaded_file.path, public_id:  uploaded_file.original_filename.slice(0,uploaded_file.original_filename.index('.')))
            image_attrs[key][:image_url] = uploaded_file.original_filename
          end
        end
      end

      [:measurement_image_url].each do |url|
        image_attrs = params[:product][url]
        if image_attrs.present?
          Cloudinary::Uploader.upload(image_attrs.path, public_id:  image_attrs.original_filename.slice(0,image_attrs.original_filename.index('.')))
          params[:product][url] = image_attrs.original_filename
        end
      end
    end
  end
end
