class CreateTransactionDetails < ActiveRecord::Migration
  def change
    create_table :transaction_details do |t|
      t.references :transaction, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true
      t.integer :quantity_imported
      t.integer :quantity_sold
      t.integer :stock
      t.decimal :revenue

      t.timestamps null: false
    end
  end
end
