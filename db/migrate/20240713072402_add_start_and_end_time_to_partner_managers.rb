class AddStartAndEndTimeToPartnerManagers < ActiveRecord::Migration
  def change
    add_column :partner_managers, :start_time, :datetime
    add_column :partner_managers, :end_time, :datetime
  end
end
