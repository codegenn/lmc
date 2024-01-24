class Message < ActiveRecord::Base
end

# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  email      :string
#  question   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
