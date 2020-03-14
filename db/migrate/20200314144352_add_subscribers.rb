class AddSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string      :email
    end
  end
end
