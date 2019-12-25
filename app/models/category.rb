class Category < ActiveRecord::Base
  validates :sort_order, numericality: { greater_than_or_equal_to: 0 }
  validates :name, presence: true

  has_many :category_products, dependent: :destroy
  has_many :products, through: :category_products
end
