class AddUserIdToPartnerManager < ActiveRecord::Migration
  def change
    add_column :partner_managers, :user_id, :integer
  end
end
