class AddRevenueToPartnerOrders < ActiveRecord::Migration
  def change
    add_column :partner_orders, :revenue, :decimal
  end
end
