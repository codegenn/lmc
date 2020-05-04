class AddPromotionPriceToProducts < ActiveRecord::Migration
  def change
    add_column :products, :out_of_stock, :boolean, default: false
    add_column :products, :promotion_price, :float
  end
end
