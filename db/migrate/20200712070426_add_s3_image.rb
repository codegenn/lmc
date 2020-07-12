class AddS3Image < ActiveRecord::Migration
  def change
    add_attachment :color_images, :color_image
    add_attachment :products, :measurement_image
    add_attachment :categories, :measurement_image
    add_attachment :categories, :category_image
    add_attachment :categories, :banner
    add_attachment :foundations, :foundation_image
  end
end
