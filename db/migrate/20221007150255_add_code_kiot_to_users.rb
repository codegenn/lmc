class AddCodeKiotToUsers < ActiveRecord::Migration
  def change
    add_column :users, :code_kiot, :integer
  end
end
