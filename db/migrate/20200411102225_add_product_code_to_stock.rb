class AddProductCodeToStock < ActiveRecord::Migration
  def change
    remove_column :products, :product_code, :string
    add_column :stocks, :product_code, :string
  end
end
