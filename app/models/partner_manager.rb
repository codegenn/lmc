class PartnerManager < ActiveRecord::Base
  belongs_to :partner_order
  has_many :partner_managers_details, dependent: :destroy
  accepts_nested_attributes_for :partner_managers_details, :allow_destroy => true
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
#  partner_order_id :integer
#  start_time       :datetime
#  end_time         :datetime
#
# Indexes
#
#  index_partner_managers_on_partner_order_id  (partner_order_id)
#
