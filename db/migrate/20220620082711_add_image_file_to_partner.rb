class AddImageFileToPartner < ActiveRecord::Migration
  def change
    add_column :partners, :partner_image_file_name, :string
  end
end
