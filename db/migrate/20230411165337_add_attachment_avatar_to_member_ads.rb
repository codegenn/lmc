class AddAttachmentAvatarToMemberAds < ActiveRecord::Migration
  def self.up
    change_table :member_ads do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :member_ads, :avatar
  end
end
