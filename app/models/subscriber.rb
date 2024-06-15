class Subscriber < ActiveRecord::Base
  # Regular expression to validate phone numbers with optional country code and delimiters
  PHONE_REGEX = /\A(\+?\d{1,2}\s?)?(\(?\d{3}\)?[\s.-]?)?\d{3}[\s.-]?\d{4}\z/
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Validate presence and format of email
  validates :email, presence: false, format: { with: EMAIL_REGEX }
  
  # Validate presence and format of phone before stripping non-numeric characters
  validates :phone, presence: true
end

# == Schema Information
#
# Table name: subscribers
#
#  id    :integer          not null, primary key
#  email :string
#  phone :string
#
