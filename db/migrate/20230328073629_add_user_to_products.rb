class AddUserToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :admin_user, index: true, foreign_key: true
  end
end
