class PartnerManagersDetail < ActiveRecord::Base
  belongs_to :partner_manager
end

# == Schema Information
#
# Table name: partner_managers_details
#
#  id                 :integer          not null, primary key
#  size               :string
#  stock              :integer
#  sold_product       :integer
#  partner_manager_id :integer
#  quantity_in        :integer
#  quantity_sold      :integer
#
# Indexes
#
#  index_partner_managers_details_on_partner_manager_id  (partner_manager_id)
#
