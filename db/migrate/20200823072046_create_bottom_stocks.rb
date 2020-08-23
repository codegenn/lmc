class CreateBottomStocks < ActiveRecord::Migration
  def change
    create_table :bottom_stocks do |t|
      t.references  :product
      t.string      :size
    end
    add_reference :line_items, :bottom_stock, index: true
  end
end
