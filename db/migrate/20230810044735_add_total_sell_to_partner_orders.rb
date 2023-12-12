class AddTotalSellToPartnerOrders < ActiveRecord::Migration
  def change
    add_column :partner_orders, :total_sell, :integer 
  end
end
