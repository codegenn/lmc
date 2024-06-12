class AddPhoneToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :phone, :string
  end
end
