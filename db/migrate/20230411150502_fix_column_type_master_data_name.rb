class FixColumnTypeMasterDataName < ActiveRecord::Migration
  def change
    rename_column :master_data, :type, :type_name
  end
end
