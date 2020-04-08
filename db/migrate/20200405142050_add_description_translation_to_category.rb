class AddDescriptionTranslationToCategory < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        Category.add_translation_fields! description: :string
      end

      dir.down do
        remove_column :category_translations, :description
      end
    end
  end
end
