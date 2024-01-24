# app/admin/product_sold.rb

ActiveAdmin.register ProductSold do
  permit_params :sold, :product_id

  form do |f|
    inputs do
      input :sold
      f.input :product_id, as: :select, collection: Product.all.order(:title).pluck(:title, :id)
      actions
    end
  end

  action_item :import_csv, only: [:index] do
    link_to 'Import CSV', action: "upload_csv"
  end

  action_item :download_template, only: [:index] do
    link_to 'Download Template', "https://docs.google.com/spreadsheets/u/1/d/1DkX-p4hbSGaXu5JQhE0edPFEWsffZa-wcM6jngjhBUw/export?format=csv&blank=true", method: :get
  end

  collection_action :upload_csv do
    render "admin/product_solds/upload_csv"
  end

  collection_action :import_csv, method: :post do
    if params[:dump][:file].present?
      require 'csv'

      begin
        ActiveRecord::Base.transaction do
          file = params[:dump][:file].tempfile
          CSV.foreach(file.path, headers: true) do |row|
            product = Product.find_by(slug: row['Product_slug'])
            ps = ProductSold.find_by(product_id: product.id)
            if ps.present?
              ps.update(sold: row['Sold'])
            else
              ProductSold.create(sold: row['Sold'], product: product)
            end
          end
        end
        redirect_to admin_product_solds_path, notice: "CSV imported successfully!"
      rescue StandardError => e
        redirect_to upload_csv_admin_product_solds_path, alert: "Error: #{e.message}"
      end
    else
      redirect_to upload_csv_admin_product_solds_path, alert: "Please upload a CSV file."
    end
  end
end
