class Application < ActiveRecord::Base
  has_attached_file :cv
  belongs_to :job
  validates :name, :email, :phone_number, presence: true
  validates_attachment :cv, :presence => true
  validates_attachment_content_type :cv, :content_type => [
    'text/css',
    'text/html',
    'text/plain',
    'text/richtext',
    'text/scriptlet',
    'text/tab-separated-values',
    'text/webviewhtml',
    'text/x-component',
    'text/x-setext',
    'text/x-vcard',
    'application/pdf',
    'x-unknown/pdf',
    'application/msword',
    'text/xml'
  ]
end

# == Schema Information
#
# Table name: applications
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  phone_number    :string
#  cv_file_name    :string
#  cv_content_type :string
#  cv_file_size    :bigint
#  cv_updated_at   :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  job_id          :integer
#
# Indexes
#
#  index_applications_on_job_id  (job_id)
#
