class AddColStatusToMemberAds < ActiveRecord::Migration
  def change
    add_column :member_ads, :status, :boolean
  end
end
