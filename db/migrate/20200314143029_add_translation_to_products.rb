class AddTranslationToProducts < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        Product.add_translation_fields! promotion: :string
      end

      dir.down do
        remove_column :product_translations, :promotion
      end
    end
  end
end
