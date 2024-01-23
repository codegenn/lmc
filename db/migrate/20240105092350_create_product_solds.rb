class CreateProductSolds < ActiveRecord::Migration
  def change
    create_table :product_solds do |t|
      t.string :sold
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
