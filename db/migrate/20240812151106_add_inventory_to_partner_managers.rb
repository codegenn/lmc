class AddInventoryToPartnerManagers < ActiveRecord::Migration
  def change
    add_column :partner_managers, :inventory, :integer
  end
end
