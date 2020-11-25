class Order < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  belongs_to :user

  validates :first_name, :last_name, :phone, :city, :district, :address, :email, presence: true
  validates_format_of :email,:with => Devise::email_regexp

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      price = item.stock.product_promotion_price.present? ? item.stock.product_promotion_price : item.stock.product_price
      item.price = price
      line_items << item
    end
    self.voucher_code = cart.voucher_code
    self.sub_total_price = total_price
    self.grand_total = calculate_grand_total(cart)
    discount = Voucher.where(code: self.voucher_code, active: true).first
    discount.update(active: false) if discount.present? && (discount.voucher_type == 'Buy 1 get 1 free' || discount.one_time_use?)
  end

  def total_price
    calculator.order_total_price
  end

  def calculate_grand_total(cart)
    calculator.calculate_grand_total(cart)
  end

  def total_products
    calculator.total_products
  end

  private
  def calculator
    @calculator ||= Calculator.new(line_items: line_items, voucher_code: voucher_code)
  end
end
