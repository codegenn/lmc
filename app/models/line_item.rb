class LineItem < ActiveRecord::Base
  belongs_to :stock
  belongs_to :cart
  belongs_to :order

  validates :quantity, numericality: { greater_than_or_equal_to: 1 }

  def total_price
    stock.product_price * quantity
  end
end
