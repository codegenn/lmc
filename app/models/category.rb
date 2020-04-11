class Category < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_url, use: :slugged

  validates :sort_order, numericality: { greater_than_or_equal_to: 0 }
  validates :name, presence: true
  default_scope { order('sort_order ASC') }
  translates :name, :description
  active_admin_translates :name do
    validates_presence_of :name
  end

  has_many :category_products, dependent: :destroy
  has_many :products, through: :category_products

  def should_generate_new_friendly_id?
    slug.blank? || self.slug_url_changed?
  end
end
