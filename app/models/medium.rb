class Medium < ActiveRecord::Base
    validates :media_image, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png|jpeg)\Z}i,
    message: 'must be a URL for GIF, JPG, JPEG or PNG image'
  }

  has_attached_file :media_image, :s3_protocol => :https
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :media_image, :content_type => /image/
end

# == Schema Information
#
# Table name: media
#
#  id                       :integer          not null, primary key
#  media_image_content_type :string
#  url                      :string
#  media_image_file_name    :string
#  alt                      :string
#  media_image              :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
