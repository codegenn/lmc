class FavoriteProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :favorite

  validates :product, :favorite, presence: true
  validates :product_id, uniqueness: { scope: :favorite_id }
end

# == Schema Information
#
# Table name: favorite_products
#
#  id          :integer          not null, primary key
#  product_id  :integer
#  favorite_id :integer
#
