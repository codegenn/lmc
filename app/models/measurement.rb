class Measurement < ActiveRecord::Base
  belongs_to :product
  validates :size, :color, presence: true
end
