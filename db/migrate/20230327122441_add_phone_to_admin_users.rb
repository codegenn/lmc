class AddPhoneToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :phone, :string, default: ""
    add_column :admin_users, :name, :string, default: ""
    add_column :admin_users, :address, :string, default: ""
    add_column :admin_users, :commission, :float, default: 0
    add_column :admin_users, :status, :boolean, default: false
  end
end
