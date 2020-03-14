class AddPromotionToProducts < ActiveRecord::Migration
  def change
    add_column :products, :has_promotion, :boolean, default: false
    add_column :products, :promotion, :string
  end
end
