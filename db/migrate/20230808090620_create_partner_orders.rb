class CreatePartnerOrders < ActiveRecord::Migration
  def change
    create_table :partner_orders do |t|
      t.decimal :fee
      t.integer :product_id
      t.integer :total_products
      t.integer :inventory

      t.timestamps null: false
    end
  end
end
