class AddNumberToMasterDatums < ActiveRecord::Migration
  def change
    add_column :member_ads, :number, :integer
  end
end
