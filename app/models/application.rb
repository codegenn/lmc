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
