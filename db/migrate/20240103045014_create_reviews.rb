class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :customer_name
      t.text :content
      t.integer :star_rating
      t.boolean :status
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
