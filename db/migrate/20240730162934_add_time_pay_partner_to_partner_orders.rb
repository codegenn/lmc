class AddTimePayPartnerToPartnerOrders < ActiveRecord::Migration
  def change
    add_column :partner_orders, :time_pay_partner, :datetime
  end
end
