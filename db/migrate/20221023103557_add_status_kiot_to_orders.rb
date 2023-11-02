class AddStatusKiotToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :sync_kiot, :boolean
  end
end
