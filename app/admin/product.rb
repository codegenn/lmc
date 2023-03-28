ActiveAdmin.register Product do

  # permit_params :is_best_seller, :is_promotion, :is_new_arrival, :image_url, :is_hidden, :out_of_stock, :promotion_price, :price, :sort_order,
  #               :has_promotion, :measurement_image_url, :measurement_image, :slug_url, category_ids: [],
  #               stocks_attributes: [:id, :_destroy, :size, :color, :product_code, :quantity], bottom_stocks_attributes: [:id, :_destroy, :size, :quantity],
  #               product_images_attributes: [:id, :_destroy, :url, :pimage], color_images_attributes: [:id, :_destroy, :image_url, :color_name, :color_image],
  #               translations_attributes: [:id, :locale, :title, :description, :promotion, :short_description, :measurement_description, :_destroy]

  index do
    selectable_column
    id_column
    column :title
    column :price
    column :slug
    # translation_status
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
        image_form.input :pimage, as: :file, label: 'product image', hint: image_form.object.try(:url) ? cl_image_tag(image_form.object.try(:url), width: 200) : image_tag(image_form.object.pimage.url, :width => 200)
      end
      f.input :measurement_image, as: :file, hint: f.object.try(:measurement_image_url) ? cl_image_tag(f.object.try(:measurement_image_url), width: 200) : image_tag(f.object.measurement_image.url, width: 200)
      f.input :out_of_stock, as: :boolean
      f.input :is_hidden, as: :boolean
      f.has_many :stocks, heading: false, allow_destroy: true do |stocks_form|
        stocks_form.input :size
        stocks_form.input :color, as: :string
        stocks_form.input :product_code
        stocks_form.input :quantity
      end
      f.has_many :bottom_stocks, heading: false, allow_destroy: true do |stocks_form|
        stocks_form.input :size
      end
      f.has_many :color_images, heading: false, allow_destroy: true do |colors_form|
        colors_form.input :color_name, as: :string
        colors_form.input :color_image, as: :file, hint: colors_form.object.try(:image_url) ? cl_image_tag(colors_form.object.try(:image_url), width: 50) : image_tag(colors_form.object.color_image.url, :width => 50)
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
        product.measurement_image_url ? cl_image_tag(product.measurement_image_url, class: 'my_image_size', width: 200) : image_tag(product.measurement_image.url, class: 'my_image_size', width: 200)
      end
      attributes_table_for product.color_images do
        row :color_name
        row :image_url do |ad|
          if ad.image_url.present?
            cl_image_tag ad.image_url, :width => 50
          else
            image_tag ad.color_image.url, :width => 50
          end
        end
      end
      attributes_table_for product.product_images do
        row :product_image do |ad|
          if ad.url.present?
            cl_image_tag ad.url, :width => 400
          else
            image_tag ad.pimage.url, :width => 400
          end
        end
      end
      row :out_of_stock
      row :is_hidden
      attributes_table_for product.stocks do
        row :size
        row :color
        row :product_code
        row :quantity
      end
      # attributes_table_for product.bottom_stocks do
      #   row :size
      # end
    end
    active_admin_comments
  end

  batch_action :update_false_arrival do |ids|
    Product.where(id: ids).update_all(is_new_arrival: false)
    redirect_to collection_path, alert: "updated all"
  end

  batch_action :update_true_arrival do |ids|
    Product.where(id: ids).update_all(is_new_arrival: true)
    redirect_to collection_path, alert: "updated all"
  end

  controller do
    def scoped_collection
      if current_admin_user.permission == 2
        super
      else
        super.where(admin_user_id: current_admin_user.id)
      end
    end

    before_action :upload_product_image, only: [:create, :update]
    after_action :add_kiot, only: [:create]
    # after_action :update_kiot, only: [:update]

    # def index
    #   @products.where(admin_user_id: current_admin_user.id)
    # end

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

    def add_kiot
      @product.stocks.each do |stock|
        payload = payload_add(stock)
        KiotViet.add_product(payload, token)
      end
    end

    def update_kiot
      @product.stocks.each do |stock|

        payload = payload_add(stock)
        KiotViet.update_product(payload, token, get_id_kiot(stock.product_code))
      end
    end

    def get_id_kiot(product_code)
      repo = KiotViet.get_product(token, product_code)
      data = JSON.parse(repo.body)
      return data["inventories"].last["productId"]
    end

    def token
      KiotViet.configure do |config|
        config.client_id = ENV['KIOT_CLIENT_ID']
        config.client_secret = ENV['KIOT_CLIENT_SECRET']
      end
      respon = KiotViet.get_token
      token = respon["access_token"]
      return "Bearer ".concat(token)
    end

    def create
      create! { |success, failure|
        failure.html do
          flash[:error] = "Error(s) : #{resource.errors.full_messages.join(',')}"
          redirect_to :back
        end
      }
    end

    def payload_add(stock)
      payloads = {
        "createdDate": "#{Time.now}",
        "code": stock.product_code,
        "barCode": stock.product_code,
        "name": @product.title,
        "fullName": @product.title,
        "categoryId": @product&.category_ids.last,
        "categoryName": Category&.find(@product&.category_ids.last).name,
        "allowsSale": true,
        "type": 2,
        "hasVariants": false,
        "weight": 0,
        "unit": "VND",
        "conversionValue": 1,
        "description": "",
        "modifiedDate": "#{Time.now}",
        "isActive": true,
        "description": @product.description,
        "attributes": [
          {
            "attributeName": "SIZE",
            "attributeValue": stock.size
          },
          {
            "attributeName": "MÀU SẮC",
            "attributeValue": stock.color
          },
        ],
        "inventories": [
          {
            "branchId": 31669,
            "branchName": "Chi nhánh trung tâm",
            "cost": @product.price,
            "onHand": stock.quantity,
            "reserved": 0,
            "actualReserved": 0,
            "minQuantity": 0,
            "maxQuantity": 99999999,
            "isActive": true
          }
        ],
        "images": [
          @product.product_images.last.thumb_url.to_s
        ]
      }
      return payloads
    end
  end
end
