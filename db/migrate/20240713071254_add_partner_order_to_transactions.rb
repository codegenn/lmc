class AddPartnerOrderToTransactions < ActiveRecord::Migration
  def change
    add_reference :partner_managers, :partner_order, index: true, foreign_key: true
    remove_reference :partner_managers, :partner_user, foreign_key: true
  end
end
