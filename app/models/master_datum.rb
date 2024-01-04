class MasterDatum < ActiveRecord::Base
end

# == Schema Information
#
# Table name: master_data
#
#  id         :integer          not null, primary key
#  type_name  :string
#  key        :string
#  value      :string
#  status     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
