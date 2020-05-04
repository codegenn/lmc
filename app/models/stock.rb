class Stock < ActiveRecord::Base
  belongs_to :product
  validates :size, :color, presence: true
  delegate :title, :price, :promotion_price, to: :product, prefix: true
end
