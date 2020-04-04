class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone,
            :presence => {:message => 'Only positive number without spaces are allowed'},
            :numericality => true,
            :length => { :minimum => 6, :maximum => 15 }
  has_many :orders
  has_one :favorite
end
