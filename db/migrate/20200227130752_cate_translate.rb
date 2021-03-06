class CateTranslate < ActiveRecord::Migration
  def self.up
    Category.create_translation_table!({
                                        :name => :string,
                                      }, {
                                        :migrate_data => true,
                                        :remove_source_columns => true
                                      })
  end

  def self.down
    Category.drop_translation_table! :migrate_data => true
  end
end
