class AddSlugUrlToFfoundation < ActiveRecord::Migration
  def change
    add_column :foundations, :slug_url, :string
  end
end
