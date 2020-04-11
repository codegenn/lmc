class AddSlugs < ActiveRecord::Migration
  def change
    add_column :products, :slug, :string
    add_index :products, :slug, unique: true
    add_column :products, :slug_url, :string
    add_column :categories, :slug, :string
    add_index :categories, :slug, unique: true
    add_column :categories, :slug_url, :string
  end
end
