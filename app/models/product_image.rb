class ProductImage < ActiveRecord::Base
  belongs_to :product
  validates :url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png|jpeg)\Z}i,
    message: 'must be a URL for GIF, JPG, JPEG or PNG image'
  }

  has_attached_file :pimage, :s3_protocol => :https
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :pimage, :content_type => /image/

  def image_url
    if self.url
      self.url
    else
      self.pimage.url
    end
  end

  def thumb_url
    if self.url
      "http://res.cloudinary.com/dbysq36qu/image/upload/#{self.url}"
    else
      self.pimage.url
    end
  end
end

# == Schema Information
#
# Table name: product_images
#
#  id                  :integer          not null, primary key
#  product_id          :integer
#  url                 :string
#  pimage_file_name    :string
#  pimage_content_type :string
#  pimage_file_size    :bigint
#  pimage_updated_at   :datetime
#
