class BottomStock < ActiveRecord::Base
  belongs_to :product
  validates :size, presence: true
end

# == Schema Information
#
# Table name: bottom_stocks
#
#  id         :integer          not null, primary key
#  product_id :integer
#  size       :string
#
