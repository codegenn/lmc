class AddSortOrderToProducts < ActiveRecord::Migration
  def change
    add_column :products, :sort_order, :integer, default: 0
  end
end
