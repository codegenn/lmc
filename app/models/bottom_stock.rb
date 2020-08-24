class BottomStock < ActiveRecord::Base
  belongs_to :product
  validates :size, presence: true
end
