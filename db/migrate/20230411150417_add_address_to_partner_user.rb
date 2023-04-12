class AddAddressToPartnerUser < ActiveRecord::Migration
  def change
    add_column :partner_users, :address, :string
    add_column :partner_users, :phone, :string
    add_column :partner_users, :name, :string
    add_column :partner_users, :info, :string
  end
end
