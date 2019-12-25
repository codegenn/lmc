class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  before_create :set_cart_code
  accepts_nested_attributes_for :line_items, :allow_destroy => true

  def add_product(stock_id)
    current_line_item = line_items.where(stock_id: stock_id).first_or_initialize
    current_line_item.increment(:quantity)
    current_line_item
  end

  def total_price
    calculator.total_price
  end

  def total_products
    calculator.total_products
  end

  private
  def calculator
    @calculator ||= Order::Calculator.new(line_items: line_items)
  end

  def set_cart_code
    self.code = Devise.friendly_token
  end
end
