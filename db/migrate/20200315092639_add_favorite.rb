class AddFavorite < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.string      :code
      t.references  :user
    end

    create_table :favorite_products do |t|
      t.references  :product
      t.references  :favorite
    end
  end
end
