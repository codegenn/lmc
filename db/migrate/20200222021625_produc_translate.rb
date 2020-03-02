class ProducTranslate < ActiveRecord::Migration
  def self.up
    Product.create_translation_table!({
                                    :title => :string,
                                    :short_description => :text,
                                    :description => :text
                                   }, {
                                     :migrate_data => true,
                                     :remove_source_columns => true
                                   })
  end

  def self.down
    Product.drop_translation_table! :migrate_data => true
  end
end
