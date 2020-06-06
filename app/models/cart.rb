class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  before_create :set_cart_code
  accepts_nested_attributes_for :line_items, :allow_destroy => true
  validate :validate_voucher, if: :voucher_code_changed?

  def add_product(stock_id, quantity=1)
    current_line_item = line_items.where(stock_id: stock_id).first_or_initialize
    current_line_item.increment(:quantity, quantity.to_i)
    current_line_item
  end

  def total_price
    calculator.total_price
  end

  def calculate_grand_total
    total = total_price
    discount = Voucher.where(code: self.voucher_code, voucher_type: '50 off', active: true).first
    if discount.present?
      total = total - (total * 50 / 100)
    end
    total
  end

  def total_products
    calculator.total_products
  end

  private
  def calculator
    @calculator ||= Order::Calculator.new(line_items: line_items)
  end

  def validate_voucher
    discount = Voucher.where(code: self.voucher_code, active: true).first
    unless discount.present?
      errors.add(:voucher_code, I18n.t("voucher.invalid"))
    end
  end

  def set_cart_code
    self.code = Devise.friendly_token
  end
end
