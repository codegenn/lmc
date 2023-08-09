class AddAvatarContentTypeToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :avatar_content_type, :string
  end
end
