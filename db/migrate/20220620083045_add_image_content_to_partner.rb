class AddImageContentToPartner < ActiveRecord::Migration
  def change
    add_column :partners, :partner_image_content_type, :string
  end
end
