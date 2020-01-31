class AddingCheckToProducts < ActiveRecord::Migration
  def change
    add_column :products, :is_best_seller, :boolean, default: false
    add_column :products, :is_promotion, :boolean, default: false
    add_column :products, :is_new_arrival, :boolean, default: false
  end
end
