class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string  :author
      t.string  :title
      t.text    :short_description
      t.text    :content
      t.string  :image

      t.timestamps null: false
    end
  end
end
