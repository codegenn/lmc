class PartnerOrder < ActiveRecord::Base
  # belongs_to :product
  has_many :partner_managers, dependent: :destroy
  # validates :fee, :total_products, :inventory, presence: true
  # validates :fee, :total_products, :inventory, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :partner_user, foreign_key: 'user_id'
  accepts_nested_attributes_for :partner_managers, :allow_destroy => true
end

# == Schema Information
#
# Table name: partner_orders
#
#  id               :integer          not null, primary key
#  fee              :decimal(, )
#  product_id       :integer
#  total_products   :integer
#  inventory        :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#  total_sell       :integer
#  stock_item       :string
#  start_time       :datetime
#  end_time         :datetime
#  time_pay         :decimal(, )
#  time_pay_partner :datetime
#  revenue          :decimal(, )
#  note             :string
#
