class ChangeColumnImage < ActiveRecord::Migration
  def change
    rename_column :partners, :image, :partner_image
  end
end
