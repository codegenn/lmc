class LineItem < ActiveRecord::Base
  belongs_to :stock
  belongs_to :bottom_stock
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

# == Schema Information
#
# Table name: line_items
#
#  id              :integer          not null, primary key
#  stock_id        :integer
#  cart_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#  quantity        :integer          default(0)
#  order_id        :integer
#  price           :float
#  bottom_stock_id :integer
#
# Indexes
#
#  index_line_items_on_bottom_stock_id  (bottom_stock_id)
#  index_line_items_on_cart_id          (cart_id)
#  index_line_items_on_order_id         (order_id)
#  index_line_items_on_stock_id         (stock_id)
#
