class AddProductDetailstoProducts < ActiveRecord::Migration
  def up
    add_column :products, :measurement_image_url, :string
    Product.add_translation_fields! measurement_description: :text
  end
  def down
    remove_column :product_translations, :measurement_description
    remove_column :products, :measurement_image_url
  end
end
