class AddStockToPartnerOrders < ActiveRecord::Migration
  def change
    add_column :partner_orders, :stock_item, :string
  end
end
