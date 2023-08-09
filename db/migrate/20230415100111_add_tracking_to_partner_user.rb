class AddTrackingToPartnerUser < ActiveRecord::Migration
  def change
    add_column :partner_users, :tracking, :string
  end
end
