class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :media_image_content_type
      t.string :url
      t.string :media_image_file_name
      t.string :alt
      t.string :media_image

      t.timestamps null: false
    end
  end
end
