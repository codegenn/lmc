class Product < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_url, use: :slugged
  # include PgSearch
  # pg_search_scope :search, against: [:title, :short_description]

  # paginates_per 9
  # max_paginates_per 50
  # PAGINATION_OPTIONS = [9, 12 , 15, 18]
  translates :title, :short_description, :description, :promotion, :measurement_description
  active_admin_translates :title, :short_description, :description do
    validates_presence_of :title
  end
  scope :best_sellers, -> { where(is_best_seller: true) }
  scope :promotion, -> { where(is_promotion: true) }
  scope :new_arrivals, -> { where(is_new_arrival: true) }

  has_many :category_products, dependent: :destroy
  has_many :categories, through: :category_products
  has_many :product_images
  has_many :color_images
  has_many :stocks
  belongs_to :favorite

  validates :title, :description, :short_description, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: true
  accepts_nested_attributes_for :product_images, allow_destroy: true
  accepts_nested_attributes_for :color_images, :allow_destroy => true
  accepts_nested_attributes_for :stocks, :allow_destroy => true

  def should_generate_new_friendly_id?
    slug.blank? || self.slug_url_changed?
  end
end
