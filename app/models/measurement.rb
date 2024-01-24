class Measurement < ActiveRecord::Base
  belongs_to :product
  validates :size, :color, presence: true
end

# == Schema Information
#
# Table name: measurements
#
#  id                   :integer          not null, primary key
#  category_id          :integer
#  size                 :string
#  bust                 :string
#  waist                :boolean
#  length               :boolean
#  sleeve_length        :boolean
#  sleeve_circumference :boolean
#
