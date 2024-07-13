class CreateHaves < ActiveRecord::Migration
  def change
    create_table :haves do |t|
      t.datetime :time
      t.integer :product_sold
      t.decimal :revenue
      t.decimal :pay_for_partner
      t.text :note
      t.decimal :fee

      t.timestamps null: false
    end
  end
end
