class CreateColorImage < ActiveRecord::Migration
  def change
    create_table :color_images do |t|
      t.references  :product
      t.string      :image_url
      t.string      :color_name
    end
  end
end
