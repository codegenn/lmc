class PartnerOrder < ActiveRecord::Base
  # belongs_to :product

  # validates :fee, :total_products, :inventory, presence: true
  # validates :fee, :total_products, :inventory, numericality: { greater_than_or_equal_to: 0 }

  # belongs_to :partner_user
end
