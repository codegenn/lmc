class AddCodeToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :code, :string
  end
end
