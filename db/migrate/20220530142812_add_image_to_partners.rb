class AddImageToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :alt, :string
    add_column :partners, :url, :string
    add_column :partners, :image, :string
  end
end
