class ProductImage < ActiveRecord::Base
  belongs_to :product
  validates :url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png|jpeg)\Z}i,
    message: 'must be a URL for GIF, JPG, JPEG or PNG image'
  }
end
