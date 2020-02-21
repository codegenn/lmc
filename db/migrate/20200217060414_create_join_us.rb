class CreateJoinUs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string  :title
      t.text    :short_description
      t.text    :content

      t.timestamps null: false
    end

    create_table :applications do |t|
      t.string  :name
      t.string  :email
      t.string  :phone_number
      t.attachment :cv

      t.timestamps null: false
    end

    create_table :partners do |t|
      t.string  :email

      t.timestamps null: false
    end

    create_table :messages do |t|
      t.string  :email
      t.string  :question

      t.timestamps null: false
    end
  end
end
