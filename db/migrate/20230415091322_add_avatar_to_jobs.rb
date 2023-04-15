class AddAvatarToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :avatar, :string
  end
end
