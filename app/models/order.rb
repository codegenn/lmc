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

  def order_detail
    self.line_items.map do |item|
      {
        "productCode": item.stock.product_code,
        "productName": item.stock.product.title,
        "quantity": item.quantity,
        "price": item.price,
        "note": self.note
      }
    end
  end

  def order_customer
    customer = self.user
    {
      "code": customer.kiot_id,
      "name": customer.username,
      "contactNumber": self.phone,
      "address": self.address,
      "wardName": "#{self.district} #{self.city}" ,
      "email": customer.email,
      "comments": self.note
    }
  end

  def order_payment
    v = Voucher.where(code: self.voucher_code).first
    {
      "Method": "Voucher", 
      "MethodStr": "Voucher",
      "Amount": self.sub_total_price - self.grand_total,
      "VoucherId": 30996,
      "VoucherCampaignId": 30087
    }
  end

  def sync_order_kiot
    payload = {
      "isApplyVoucher": self.voucher_code.present?,
      "purchaseDate": DateTime.now().strftime("%Y-%m-%d"),
      "branchId": 31669,
      "description": self.note,
      "method": self.payment_method,
      "totalPayment": self.sub_total_price,
      "orderDetails": order_detail,
      "customer": order_customer,
      "Payments":[
        self.voucher_code.present? ? order_payment : {}
      ]
    }
    KiotViet.add_order(payload, token)
  end

  def token
    KiotViet.configure do |config|
      config.client_id = ENV['KIOT_CLIENT_ID']
      config.client_secret = ENV['KIOT_CLIENT_SECRET']
    end
  
    respon = KiotViet.get_token
  
    token = respon["access_token"]
  
    return "Bearer ".concat(token)
  end

  private
  def calculator
    @calculator ||= Calculator.new(line_items: line_items, voucher_code: voucher_code)
  end
end

# == Schema Information
#
# Table name: orders
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  first_name      :string
#  last_name       :string
#  email           :string
#  phone           :string
#  city            :string
#  district        :string
#  note            :string
#  address         :text
#  created_at      :datetime
#  updated_at      :datetime
#  tracking        :string
#  status          :string
#  payment_method  :string
#  sub_total_price :float
#  grand_total     :float
#  voucher_code    :string
#  payment_status  :string
#  sync_kiot       :boolean
#
# Indexes
#
#  index_orders_on_user_id  (user_id)
#
