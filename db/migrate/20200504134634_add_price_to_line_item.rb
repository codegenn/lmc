class AddPriceToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :price, :float
  end
end
