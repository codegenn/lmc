class AddPermissionToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :permission, :integer, default: 0
  end
end
