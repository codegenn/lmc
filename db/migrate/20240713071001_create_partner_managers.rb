class CreatePartnerManagers < ActiveRecord::Migration
  def change
    create_table :partner_managers do |t|
      t.datetime :time
      t.integer :product_sold
      t.decimal :revenue
      t.decimal :pay_for_partner
      t.text :note
      t.decimal :fee
      t.references :partner_user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
