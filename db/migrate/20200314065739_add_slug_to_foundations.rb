class AddSlugToFoundations < ActiveRecord::Migration
  def change
    add_column :foundations, :slug, :string
    add_index :foundations, :slug, unique: true
  end
end
