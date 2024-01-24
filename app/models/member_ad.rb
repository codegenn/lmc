class MemberAd < ActiveRecord::Base
  has_attached_file :avatar, :s3_protocol => :https

  validates_attachment_content_type :avatar, :content_type => /image/
end

# == Schema Information
#
# Table name: member_ads
#
#  id                  :integer          not null, primary key
#  name                :string
#  role                :string
#  description         :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  avatar              :string
#  status              :boolean
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :bigint
#  avatar_updated_at   :datetime
#  number              :integer
#
