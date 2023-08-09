class Medium < ActiveRecord::Base
    validates :media_image, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png|jpeg)\Z}i,
    message: 'must be a URL for GIF, JPG, JPEG or PNG image'
  }

  has_attached_file :media_image, :s3_protocol => :https
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :media_image, :content_type => /image/
end
