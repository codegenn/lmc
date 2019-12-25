class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string      :name
      t.integer     :sort_order
      t.string      :measurement_image_url
    end
    create_table :category_products do |t|
      t.references  :product
      t.references  :category
    end
    create_table :stocks do |t|
      t.references  :product
      t.string      :size
      t.string      :color
      t.boolean     :in_stock
    end
    create_table :measurements do |t|
      t.references  :category
      t.string      :size
      t.string      :bust
      t.boolean     :waist
      t.boolean     :length
      t.boolean     :sleeve_length
      t.boolean     :sleeve_circumference
    end
  end
end
