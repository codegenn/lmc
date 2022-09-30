class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2, :facebook]
  # validates :first_name, presence: true
  # validates :last_name, presence: true
  validates :phone,
            :presence => {:message => 'Only positive number without spaces are allowed'},
            :numericality => true,
            :length => { :minimum => 6, :maximum => 15 }
  has_many :orders
  has_one :favorite

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
    if user
      user
    else
      if access_token.provider == "facebook"
        user = User.create(username: data['name'],
          email: data['email'],
          password: Devise.friendly_token[0,20],
          uid: access_token[:uid],
          provider: access_token[:provider],
          first_name: data["name"].split(" ").last,
          last_name: data["name"].split(" ").first,
          avatar: data["image"],
          phone: 999999999
        )
      else
        user = User.create(username: data['name'],
            email: data['email'],
            password: Devise.friendly_token[0,20],
            uid: access_token[:uid],
            provider: access_token[:provider],
            first_name: data["first_name"],
            last_name: data["last_name"],
            avatar: data["image"],
            phone: 999999999
        )
      end
    end
  end
end
