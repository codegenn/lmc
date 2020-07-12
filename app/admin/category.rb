ActiveAdmin.register Category do

  permit_params :sort_order, :measurement_image_url, :image_url, :banner_url, :slug_url,
                translations_attributes: [:id, :locale, :name, :_destroy, :description]

  index do
    id_column
    column :name
    column :description
    column :slug
    translation_status
    actions
  end

  form do |f|
    f.inputs "Category Details" do
      f.inputs "Translated fields" do
        f.translated_inputs 'ignored title', switch_locale: false do |t|
          t.input :name
          t.input :description
        end
      end
      f.input :sort_order
      f.input :slug_url
      f.input :measurement_image, as: :file, hint: f.object.try(:measurement_image_url) ? cl_image_tag(f.object.try(:measurement_image_url), width: 200) : image_tag(f.object.measurement_image.url, width: 200)
      f.input :category_image, as: :file, hint: f.object.try(:image_url) ? cl_image_tag(f.object.try(:image_url), width: 200) : image_tag(f.object.category_image.url, width: 200)
      f.input :banner, as: :file, hint: f.object.try(:banner_url) ? cl_image_tag(f.object.try(:banner_url), width: 200) : image_tag(f.object.banner.url, width: 200)
    end
    f.actions
  end

  show do |category|
    attributes_table do
      row :name
      row :slug
      row :slug_url
      row :description
      row :sort_order
      row :measurement_image do
        category.measurement_image_url ? cl_image_tag(category.measurement_image_url, class: 'my_image_size', width: 200) : image_tag(category.measurement_image.url, width: 200)
      end
      row :image_url do
        category.image_url ? cl_image_tag(category.image_url, class: 'my_image_size', width: 200) : image_tag(category.category_image.url, width: 200)
      end
      row :banner_url do
        category.banner_url ? cl_image_tag(category.banner_url, class: 'my_image_size', width: 200) : image_tag(category.banner.url, width: 200)
      end
    end
    active_admin_comments
  end

  controller do
    before_action :upload_category_image, only: [:create, :update]

    def upload_category_image
      [:measurement_image_url, :image_url, :banner_url].each do |url|
        image_attrs = params[:category][url]
        if image_attrs.present?
          Cloudinary::Uploader.upload(image_attrs.path, public_id:  image_attrs.original_filename.slice(0,image_attrs.original_filename.index('.')))
          params[:category][url] = image_attrs.original_filename
        end
      end
    end
  end
end
