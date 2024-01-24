class Subscriber < ActiveRecord::Base
  validates :email, presence: true
end

# == Schema Information
#
# Table name: subscribers
#
#  id    :integer          not null, primary key
#  email :string
#
