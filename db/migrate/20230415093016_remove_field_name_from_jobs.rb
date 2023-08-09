class RemoveFieldNameFromJobs < ActiveRecord::Migration
  def change
    remove_column :jobs, :avatar_content_type, :string
  end
end
