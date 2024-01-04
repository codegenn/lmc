class Comment < ActiveRecord::Base
  belongs_to :review
end

# == Schema Information
#
# Table name: comments
#
#  id          :integer          not null, primary key
#  review_id   :integer
#  author_name :string
#  content     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
