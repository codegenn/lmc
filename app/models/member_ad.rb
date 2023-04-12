class MemberAd < ActiveRecord::Base
  has_attached_file :avatar, :s3_protocol => :https

  validates_attachment_content_type :avatar, :content_type => /image/
end
