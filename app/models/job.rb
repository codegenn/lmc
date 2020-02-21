class Job < ActiveRecord::Base
  validates :title, :short_description, :content, presence: true
end
