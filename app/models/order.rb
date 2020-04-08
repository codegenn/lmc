class Order < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  belongs_to :user

  validates :first_name, :last_name, :phone, :city, :district, :address, :email, presence: true

  def add_line_items_from_cart(cart)
    self.tracking = "#{DateTime::now().to_time.to_i}#{self.id}"
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  def total_price
    calculator.total_price
  end

  def total_products
    calculator.total_products
  end

  private
  def calculator
    @calculator ||= Calculator.new(line_items: line_items)
  end
end
