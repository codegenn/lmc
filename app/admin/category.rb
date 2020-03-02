ActiveAdmin.register Category do

  permit_params :sort_order, :measurement_image_url, :image_url,
                translations_attributes: [:id, :locale, :name, :_destroy]

  index do
    id_column
    column :name
    translation_status
    actions
  end

  form do |f|
    f.inputs "Category Details" do
      f.inputs "Translated fields" do
        f.translated_inputs 'ignored title', switch_locale: false do |t|
          t.input :name
        end
      end
      f.input :sort_order
      f.input :measurement_image_url, as: :file, hint: cl_image_tag(f.object.try(:measurement_image_url), width: 200)
      f.input :image_url, as: :file, hint: cl_image_tag(f.object.try(:image_url), width: 200)
    end
    f.actions
  end

  show do |category|
    attributes_table do
      row :name
      row :sort_order
      row :measurement_image do
        cl_image_tag category.measurement_image_url, class: 'my_image_size', width: 200
      end
      row :image_url do
        cl_image_tag category.image_url, class: 'my_image_size', width: 200
      end
    end
    active_admin_comments
  end

  controller do
    before_action :upload_category_image, only: [:create, :update]

    def upload_category_image
      [:measurement_image_url, :image_url].each do |url|
        image_attrs = params[:category][url]
        if image_attrs.present?
          Cloudinary::Uploader.upload(image_attrs.path, public_id:  image_attrs.original_filename.slice(0,image_attrs.original_filename.index('.')))
          params[:category][url] = image_attrs.original_filename
        end
      end
    end
  end
end
