class AddOneTimeToVoucher < ActiveRecord::Migration
  def change
    add_column :vouchers, :one_time_use, :boolean, default: false
  end
end
