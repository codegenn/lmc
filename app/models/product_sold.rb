class ProductSold < ActiveRecord::Base
  belongs_to :product
end

# == Schema Information
#
# Table name: product_solds
#
#  id         :integer          not null, primary key
#  sold       :string
#  product_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_product_solds_on_product_id  (product_id)
#
