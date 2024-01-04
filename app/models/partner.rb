class Partner < ActiveRecord::Base

  validates :partner_image, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png|jpeg)\Z}i,
    message: 'must be a URL for GIF, JPG, JPEG or PNG image'
  }

  has_attached_file :partner_image, :s3_protocol => :https
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :partner_image, :content_type => /image/
end

# == Schema Information
#
# Table name: partners
#
#  id                         :integer          not null, primary key
#  email                      :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  alt                        :string
#  url                        :string
#  partner_image              :string
#  partner_image_file_name    :string
#  partner_image_content_type :string
#
