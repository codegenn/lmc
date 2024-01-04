class Job < ActiveRecord::Base
  # validates :title, :short_description, :content, presence: true

  has_attached_file :avatar, :s3_protocol => :https
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :avatar, :content_type => /image/
end

# == Schema Information
#
# Table name: jobs
#
#  id                  :integer          not null, primary key
#  title               :string
#  short_description   :text
#  content             :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  image               :string
#  avatar              :string
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :bigint
#  avatar_updated_at   :datetime
#
