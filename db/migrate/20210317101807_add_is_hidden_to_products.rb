class AddIsHiddenToProducts < ActiveRecord::Migration
  def change
    add_column :products, :is_hidden, :boolean, default: false
  end
end
