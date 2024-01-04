class CreateReviewImages < ActiveRecord::Migration
  def change
    create_table :review_images do |t|
      t.references  :review
      t.string      :pimage
      t.string      :url
      t.string :pimage_file_name
      t.string :pimage_content_type
    end
  end
end
