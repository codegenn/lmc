class AddFieldsToPartnerManagersDetail < ActiveRecord::Migration
  def change
    add_column :partner_managers_details, :quantity_in, :integer
    add_column :partner_managers_details, :quantity_sold, :integer
  end
end
