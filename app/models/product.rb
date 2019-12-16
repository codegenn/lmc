class Product < ActiveRecord::Base
  # include PgSearch
  # pg_search_scope :search, against: [:title, :short_description]

  # paginates_per 9
  # max_paginates_per 50
  # PAGINATION_OPTIONS = [9, 12 , 15, 18]

  # has_many :category_books, dependent: :destroy
  # has_many :categories, through: :category_books

  validates :title, :description, :short_description, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: true
  has_many :product_images
  accepts_nested_attributes_for :product_images, allow_destroy: true
end
