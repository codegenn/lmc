class CreateOrderTables < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.string      :code
      t.timestamps
    end

    create_table :line_items do |t|
      t.references  :stock, index: true
      t.belongs_to :cart, index: true
      t.timestamps
    end

    create_table :orders do |t|
      t.references  :user, index: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :city
      t.string :district
      t.string :note
      t.text :address
      t.timestamps
    end
  end
end
