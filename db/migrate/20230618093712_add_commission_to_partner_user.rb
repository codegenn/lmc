class AddCommissionToPartnerUser < ActiveRecord::Migration
  def change
    add_column :partner_users, :commision, :float
  end
end
