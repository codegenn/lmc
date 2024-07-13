class PartnerManager < ActiveRecord::Base
  belongs_to :partner_order
  has_many :partner_managers_details, dependent: :destroy
  accepts_nested_attributes_for :partner_managers_details, :allow_destroy => true
  FEE = 0.35
  before_save do |partner_manager|
    order = PartnerOrder.find_by(id: partner_manager.partner_order_id)
    if order
      stock = Stock.find_by(product_code: order.stock_item)
      product = stock&.product
      if product
        partner_manager.revenue = product.price * partner_manager.product_sold
        partner_manager.fee = partner_manager.revenue * FEE
        partner_manager.pay_for_partner = partner_manager.revenue - partner_manager.fee
      end
    end
  end
end

# == Schema Information
#
# Table name: partner_managers
#
#  id               :integer          not null, primary key
#  time             :datetime
#  product_sold     :integer
#  revenue          :decimal(, )
#  pay_for_partner  :decimal(, )
#  note             :text
#  fee              :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  start_time       :datetime
#  end_time         :datetime
#  partner_order_id :integer
#  user_id          :integer
#  quantity_entered :integer
#  product_id       :integer
#
