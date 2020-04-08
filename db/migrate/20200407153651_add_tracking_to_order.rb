class AddTrackingToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :tracking, :string
  end
end
