# app/scripts/csv_import_script.rb

class CsvImportScript
  def self.process(file)
    CSV.foreach(file, headers: true) do |row|
      product_id = row['product_id']
      sold = row['sold']

      ProductSold.create(product_id: product_id, sold: sold)
    end
  end
end
