class AddTimePayToPartnerOrders < ActiveRecord::Migration
  def change
    add_column :partner_orders, :time_pay, :decimal
  end
end
