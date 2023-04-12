class CreateMemberAds < ActiveRecord::Migration
  def change
    create_table :member_ads do |t|
      t.string :name
      t.string :role
      t.text :description

      t.timestamps null: false
    end
  end
end
