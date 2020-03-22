class Foundation < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_url, use: :slugged

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
end
