class CreateVouchers < ActiveRecord::Migration
  def change
    create_table :vouchers do |t|
      t.string    :code
      t.string    :voucher_type
      t.boolean   :active
    end

    add_column :orders, :sub_total_price, :float
    add_column :orders, :grand_total, :float
    add_column :orders, :voucher_code, :string
    add_column :carts, :voucher_code, :string
  end
end
