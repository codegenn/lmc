class Foundation < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_url, use: :slugged
  has_attached_file :foundation_image
  validates_attachment_content_type :foundation_image, :content_type => /image/
  def self.main_page
    foundations = []
    %w(inspiration empowerment news).each do |category|
      foundations << Foundation.where(category: category).last(3)
    end
    foundations
  end

  def should_generate_new_friendly_id?
    slug.blank? || self.slug_url_changed?
  end

  def f_image_url
    if self.image
      self.image
    else
      self.foundation_image.url
    end
  end
end

# == Schema Information
#
# Table name: foundations
#
#  id                            :integer          not null, primary key
#  author                        :string
#  title                         :string
#  short_description             :text
#  content                       :text
#  image                         :string
#  category                      :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  slug                          :string
#  slug_url                      :string
#  foundation_image_file_name    :string
#  foundation_image_content_type :string
#  foundation_image_file_size    :bigint
#  foundation_image_updated_at   :datetime
#
# Indexes
#
#  index_foundations_on_slug  (slug) UNIQUE
#
