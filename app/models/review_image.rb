class ReviewImage < ActiveRecord::Base
  belongs_to :review
  validates :url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png|jpeg)\Z}i,
    message: 'must be a URL for GIF, JPG, JPEG or PNG image'
  }

  has_attached_file :pimage, :s3_protocol => :https
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :pimage, :content_type => /image/
end

# == Schema Information
#
# Table name: review_images
#
#  id                  :integer          not null, primary key
#  review_id           :integer
#  pimage              :string
#  url                 :string
#  pimage_file_name    :string
#  pimage_content_type :string
#
