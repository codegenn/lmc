class AddStartTimeAndEndTimeToPartnerOrders < ActiveRecord::Migration
  def change
    add_column :partner_orders, :start_time, :datetime
    add_column :partner_orders, :end_time, :datetime
  end
end
