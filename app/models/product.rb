class Product < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_url, use: :slugged
  belongs_to :admin_user
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
  scope :active, -> { where(is_hidden: false) }

  has_many :category_products, dependent: :destroy
  has_many :categories, through: :category_products
  has_many :product_images
  has_many :color_images
  has_many :stocks
  has_many :bottom_stocks
  has_many :reviews
  # has_many :parner_orders
  belongs_to :favorite
  has_attached_file :measurement_image
  has_one :product_sold
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :measurement_image, :content_type => /image/
  validates :title, :description, :short_description, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: true
  accepts_nested_attributes_for :product_images, allow_destroy: true
  accepts_nested_attributes_for :color_images, :allow_destroy => true
  accepts_nested_attributes_for :stocks, :allow_destroy => true
  accepts_nested_attributes_for :bottom_stocks, :allow_destroy => true

  PRICE_ON_ORDER = 3000000000
  COMMISSION = 0.25

  def star_rating
    avg = reviews.active.average(:star_rating) || 0
    total = reviews.active.count || 0
    star_ratings_counts = calculate_star_ratings_counts

    rate = reviews.active.map do |review|
      {
        customer_name: review.customer_name,
        content: review.content,
        star_rating: review.star_rating,
        product_img: product_images.first&.image_url, # Assuming product_images is a collection related to the product
        review_img: review.review_images.map { |image| image.pimage.url if image.pimage.present? }.compact, # Map review images and remove nil values
        product_title: title, # Assuming title is defined somewhere
        product_slug: slug, # Assuming slug is defined somewhere
        reply: review.comments.map do |comment|
          {
            author_name: "Phản hồi từ người bán",
            content: comment.content,
            status: comment.content.present?
          }
        end
      }
    end

    {
      star_ratings_counts: star_ratings_counts,
      avg: avg,
      review: rate,
      total: total
    }
  end

  def calculate_star_ratings_counts
    star_ratings_counts = {}
    (1..5).each do |rating|
      star_ratings_counts["count_#{rating}_star"] = reviews.active.where(star_rating: rating).count || 0
    end
    star_ratings_counts
  end

  def should_generate_new_friendly_id?
    slug.blank? || self.slug_url_changed?
  end

  def measurement_url
    if self.measurement_image_url
      self.measurement_image_url
    else
      self.measurement_image.url
    end
  end

  def quantity_sell(stock_item)
    po = PartnerOrder.find_by(stock_item: stock_item)
    return 0 unless po

    po.total_sell
  end

  def total_products
    stocks.map(&:quantity).inject(0, &:+)
  end

  def total_sell(stock_item)
    if !quantity_sell(stock_item) || quantity_sell(stock_item).zero?
      0
    else
      quantity_sell(stock_item) * price
    end
  end

  def inventory(stock_item)
    total_products - quantity_sell(stock_item)
  end

  def list_size
    stocks.map(&:size).join(", ")
  end

  def fees_paid_sell(commission, stock_item)
    if !quantity_sell(stock_item) || quantity_sell(stock_item).zero?
      0
    else
      total_sell(stock_item) * commission
    end
  end

  def revenue_sell(commission, stock_item)
    total_sell(stock_item) - fees_paid_sell(commission, stock_item)
  end

  def self.main_page(cats = [])
    cats.map do |category|
      products = ActiveRecord::Base.connection.execute(<<-QS
        SELECT
          (
            SELECT CONCAT('["', pi.id, '", "', pi.pimage_file_name, '"]')
            FROM product_images pi WHERE pi.product_id=p.id LIMIT 1 OFFSET 0
          ) as first_img,
          (
            SELECT CONCAT('["', pi.id, '", "', pi.pimage_file_name, '"]')
            FROM product_images pi WHERE pi.product_id=p.id LIMIT 1 OFFSET 1
          ) as second_img,
          (SELECT COUNT(DISTINCT(s.size)) FROM stocks s WHERE s.product_id = p.id) as stocks_count,
          p.id, p.out_of_stock, p.slug,
          pt.title, p.promotion_price, p.price, p.has_promotion, p.promotion
        FROM products p
        LEFT JOIN category_products cp ON p.id = cp.product_id
        LEFT JOIN product_translations pt ON pt.product_id = p.id AND pt.locale='#{I18n.locale.to_s}'
        WHERE cp.category_id = #{category['id']}
          AND p.is_hidden = false
        ORDER BY p.out_of_stock ASC, p.sort_order DESC, p.created_at DESC
        LIMIT 4
              QS
              ).as_json
      category['products'] = products&.map do |product|
        product['first_img_url'] = Product.parse_product_image product['first_img']
        product['second_img_url'] = Product.parse_product_image product['second_img']
        product
      end
      category
    end
  end

  def self.main_page_search(cats = [], id = [])
    query = ""
    id.each {|i| query += i.to_s + ","}
    query.chop!
    cats.map do |category|
      products = ActiveRecord::Base.connection.execute(<<-QS
        SELECT
          (
            SELECT CONCAT('["', pi.id, '", "', pi.pimage_file_name, '"]')
            FROM product_images pi WHERE pi.product_id=p.id LIMIT 1 OFFSET 0
          ) as first_img,
          (
            SELECT CONCAT('["', pi.id, '", "', pi.pimage_file_name, '"]')
            FROM product_images pi WHERE pi.product_id=p.id LIMIT 1 OFFSET 1
          ) as second_img,
          (SELECT COUNT(DISTINCT(s.size)) FROM stocks s WHERE s.product_id = p.id) as stocks_count,
          p.id, p.out_of_stock, p.slug,
          pt.title, p.promotion_price, p.price, p.has_promotion, p.promotion
        FROM products p
        LEFT JOIN category_products cp ON p.id = cp.product_id
        LEFT JOIN product_translations pt ON pt.product_id = p.id AND pt.locale='#{I18n.locale.to_s}'
        WHERE cp.category_id = #{category['id']}
          AND p.is_hidden = false AND p.id in (#{query})
        ORDER BY p.out_of_stock ASC, p.sort_order DESC, p.created_at DESC
        LIMIT 4
              QS
              ).as_json
      category['products'] = products&.map do |product|
        product['first_img_url'] = Product.parse_product_image product['first_img']
        product['second_img_url'] = Product.parse_product_image product['second_img']
        product
      end
      category
    end
  end

  def self.parse_product_image(product_img_str)
    product_img = JSON.parse product_img_str if product_img_str
    product_img_url = ''
    if product_img.present? && product_img.length == 2
      pi = ProductImage.new id: product_img[0]&.to_i, :pimage_file_name => product_img[1]
      pap = Paperclip::Attachment.new :pimage, pi
      product_img_url = pap.url
    end
    product_img_url
  end
end

# == Schema Information
#
# Table name: products
#
#  id                             :integer          not null, primary key
#  price                          :float
#  created_at                     :datetime
#  updated_at                     :datetime
#  is_best_seller                 :boolean          default(FALSE)
#  is_promotion                   :boolean          default(FALSE)
#  is_new_arrival                 :boolean          default(FALSE)
#  has_promotion                  :boolean          default(FALSE)
#  promotion                      :string
#  measurement_image_url          :string
#  slug                           :string
#  slug_url                       :string
#  out_of_stock                   :boolean          default(FALSE)
#  promotion_price                :float
#  sort_order                     :integer          default(0)
#  measurement_image_file_name    :string
#  measurement_image_content_type :string
#  measurement_image_file_size    :bigint
#  measurement_image_updated_at   :datetime
#  is_hidden                      :boolean          default(FALSE)
#  stock                          :integer
#  admin_user_id                  :integer
#  title                          :string
#  short_description              :text
#  description                    :text
#  promotion                      :string
#  measurement_description        :text
#
# Indexes
#
#  index_products_on_admin_user_id  (admin_user_id)
#  index_products_on_slug           (slug) UNIQUE
#
