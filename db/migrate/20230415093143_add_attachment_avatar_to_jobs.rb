class AddAttachmentAvatarToJobs < ActiveRecord::Migration
  def self.up
    change_table :jobs do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :jobs, :avatar
  end
end
