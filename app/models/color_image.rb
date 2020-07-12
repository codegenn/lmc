class ColorImage < ActiveRecord::Base
  belongs_to :product
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png|jpeg)\Z}i,
    message: 'must be a URL for GIF, JPG, JPEG or PNG image'
  }

  has_attached_file :color_image
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :color_image, :content_type => /image/

  def color_image_url
    if self.image_url
      self.image_url
    else
      self.color_image.url
    end
  end
end
