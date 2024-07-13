class AddQuantitiesToPartnerManagers < ActiveRecord::Migration
  def change
    add_column :partner_managers, :quantity_entered, :integer
  end
end
