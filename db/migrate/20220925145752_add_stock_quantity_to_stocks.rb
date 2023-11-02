class AddStockQuantityToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :quantity, :integer
  end
end
