require 'csv'
require 'active_support'
require 'active_support/core_ext'
class ChangeName
  def self.run
    csv_text = File.read("./title.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each_with_index do |row, i|
      if row[2].present? && row[3].present? && i==1
        puts "#{row[2]} / #{row[3]}"
        product = Product.find(row[3])
        if product.present?
          ActiveRecord::Base.transaction do
            product.title = row[2]
            product.save!
          end
        end
      end
    end
  end
end

ChangeName.run