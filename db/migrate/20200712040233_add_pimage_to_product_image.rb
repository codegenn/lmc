class AddPimageToProductImage < ActiveRecord::Migration
  def change
    add_attachment :product_images, :pimage
  end
end
