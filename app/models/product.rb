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
  # has_many :parner_orders
  belongs_to :favorite
  has_attached_file :measurement_image
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

  def quantity_sell
    stock_ids = stocks.ids
    line_item_ids = LineItem.where(stock_id: stock_ids).where.not(order_id: nil)
    quantity = line_item_ids.map(&:quantity).inject(0, &:+)
  end

  def total_products
    stocks.map(&:quantity).inject(0, &:+)
  end

  def total_sell
    if quantity_sell.zero?
      0
    else
      quantity_sell * price
    end
  end

  def inventory
    total_products - quantity_sell
  end

  def list_size
    stocks.map(&:size).join(", ")
  end

  def fees_paid_sell(commission)
    if quantity_sell.zero?
      0
    else
      total_sell * commission
    end
  end

  def revenue_sell(commission)
    total_sell - fees_paid_sell(commission)
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
    product_img = JSON.parse product_img_str
    product_img_url = ''
    if product_img.present? && product_img.length == 2
      pi = ProductImage.new id: product_img[0]&.to_i, :pimage_file_name => product_img[1]
      pap = Paperclip::Attachment.new :pimage, pi
      product_img_url = pap.url
    end
    product_img_url
  end
end
