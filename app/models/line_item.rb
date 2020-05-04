class LineItem < ActiveRecord::Base
  belongs_to :stock
  belongs_to :cart
  belongs_to :order

  validates :quantity, numericality: { greater_than_or_equal_to: 1 }

  def total_price
    if self.order.present?
      (self.price.to_i * quantity).to_i
    else
      price = stock.product_promotion_price.present? ? stock.product_promotion_price : stock.product_price
      (price * quantity).to_i
    end
  end
end
