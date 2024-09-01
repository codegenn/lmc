class AddProductIdToPartnerManagers < ActiveRecord::Migration
  def change
    add_column :partner_managers, :product_id, :integer
  end
end
