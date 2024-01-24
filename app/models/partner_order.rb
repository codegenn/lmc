class PartnerOrder < ActiveRecord::Base
  # belongs_to :product

  # validates :fee, :total_products, :inventory, presence: true
  # validates :fee, :total_products, :inventory, numericality: { greater_than_or_equal_to: 0 }

  # belongs_to :partner_user
end

# == Schema Information
#
# Table name: partner_orders
#
#  id             :integer          not null, primary key
#  fee            :decimal(, )
#  product_id     :integer
#  total_products :integer
#  inventory      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#  total_sell     :integer
#  stock_item     :string
#
