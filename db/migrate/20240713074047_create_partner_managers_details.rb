class CreatePartnerManagersDetails < ActiveRecord::Migration
  def change
    create_table :partner_managers_details do |t|
      t.string :size
      t.integer :stock
      t.integer :sold_product
      t.references :partner_manager, index: true, foreign_key: true
    end
  end
end
