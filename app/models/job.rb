class Job < ActiveRecord::Base
  # validates :title, :short_description, :content, presence: true

  has_attached_file :avatar, :s3_protocol => :https
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :avatar, :content_type => /image/
end
