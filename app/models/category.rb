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
  has_attached_file :measurement_image
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :measurement_image, :content_type => /image/
  has_attached_file :category_image
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :category_image, :content_type => /image/
  has_attached_file :banner
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :banner, :content_type => /image/
  has_many :category_products, dependent: :destroy
  has_many :products, through: :category_products

  def should_generate_new_friendly_id?
    slug.blank? || self.slug_url_changed?
  end

  def cate_image_url
    if self.image_url
      self.image_url
    else
      self.category_image.url
    end
  end

  def cate_banner_url
    if self.banner_url
      self.banner_url
    elsif self.banner.present?
      self.banner.url
    else
      'lmcation_banner_3_sromtg.jpg'
    end
  end
end

# == Schema Information
#
# Table name: categories
#
#  id                             :integer          not null, primary key
#  sort_order                     :integer
#  measurement_image_url          :string
#  image_url                      :string
#  banner_url                     :string
#  slug                           :string
#  slug_url                       :string
#  measurement_image_file_name    :string
#  measurement_image_content_type :string
#  measurement_image_file_size    :bigint
#  measurement_image_updated_at   :datetime
#  category_image_file_name       :string
#  category_image_content_type    :string
#  category_image_file_size       :bigint
#  category_image_updated_at      :datetime
#  banner_file_name               :string
#  banner_content_type            :string
#  banner_file_size               :bigint
#  banner_updated_at              :datetime
#  name                           :string
#  description                    :string
#
# Indexes
#
#  index_categories_on_slug  (slug) UNIQUE
#
