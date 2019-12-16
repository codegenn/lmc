class CreateProductImages < ActiveRecord::Migration
  def change
    create_table :product_images do |t|
      t.references  :product
      t.string      :url
    end
  end
end
