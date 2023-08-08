class AddUserIdToPartnerOrders < ActiveRecord::Migration
  def change
    add_column :partner_orders, :user_id, :integer
  end
end
