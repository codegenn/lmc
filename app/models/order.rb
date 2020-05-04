class Order < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  belongs_to :user

  validates :first_name, :last_name, :phone, :city, :district, :address, :email, presence: true

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      price = item.stock.product_promotion_price.present? ? item.stock.product_promotion_price : item.stock.product_price
      item.price = price
      line_items << item
    end
  end

  def total_price
    calculator.order_total_price
  end

  def total_products
    calculator.total_products
  end

  private
  def calculator
    @calculator ||= Calculator.new(line_items: line_items)
  end
end
