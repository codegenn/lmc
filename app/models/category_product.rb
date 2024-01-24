class CategoryProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :category

  validates :product, :category, presence: true
  validates :product_id, uniqueness: { scope: :category_id }
end

# == Schema Information
#
# Table name: category_products
#
#  id          :integer          not null, primary key
#  product_id  :integer
#  category_id :integer
#
