class AddColAvatarToMemberAds < ActiveRecord::Migration
  def change
    add_column :member_ads, :avatar, :string
  end
end
