class AddKiotIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :kiot_id, :string
  end
end
