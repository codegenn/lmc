class Review < ActiveRecord::Base
  belongs_to :product
  has_many :review_images
  has_many :comments

  scope :active, -> { where(status: true) }

  accepts_nested_attributes_for :review_images, allow_destroy: true
  accepts_nested_attributes_for :comments, allow_destroy: true
end

# == Schema Information
#
# Table name: reviews
#
#  id            :integer          not null, primary key
#  customer_name :string
#  content       :text
#  star_rating   :integer
#  status        :boolean
#  product_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  email         :string
#
# Indexes
#
#  index_reviews_on_product_id  (product_id)
#
