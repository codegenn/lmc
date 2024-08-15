class AddNoteToPartnerOrders < ActiveRecord::Migration
  def change
    add_column :partner_orders, :note, :string
  end
end
