class PartnerUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # has_many :partner_orders
end

# == Schema Information
#
# Table name: partner_users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  address                :string
#  phone                  :string
#  name                   :string
#  info                   :string
#  tracking               :string
#  commision              :float
#
# Indexes
#
#  index_partner_users_on_email                 (email) UNIQUE
#  index_partner_users_on_reset_password_token  (reset_password_token) UNIQUE
#
