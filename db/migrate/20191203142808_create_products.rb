class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string  :title
      t.text    :short_description
      t.text    :description
      t.float   :price
      t.timestamps
    end
  end
end
