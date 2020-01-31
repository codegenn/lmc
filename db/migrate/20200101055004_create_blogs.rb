class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :foundations do |t|
      t.string  :author
      t.string  :title
      t.text    :short_description
      t.text    :content
      t.string  :image
      t.string  :category

      t.timestamps null: false
    end
  end
end
