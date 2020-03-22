class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone,
            presence: true,
            format: { with: /\d{10}/, message: 'phone number should following include 10 digits' }
  has_many :orders
  has_one :favorite
end
