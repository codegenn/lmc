class AddingRelationToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :quantity, :integer, default: 0
    add_reference :line_items, :order, index: true
  end
end
