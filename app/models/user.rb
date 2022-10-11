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
          phone: 999999999,
          kiot_id: code_kiot
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
            phone: 999999999,
            kiot_id: code_kiot
        )
      end
      sync_customer_kiot(user, access_token)
      return user
    end
  end

  def self.token_kiot
    KiotViet.configure do |config|
      config.client_id = ENV['KIOT_CLIENT_ID']
      config.client_secret = ENV['KIOT_CLIENT_SECRET']
    end
    respon = KiotViet.get_token
    token = respon["access_token"]
    return "Bearer ".concat(token)
  end

  def self.sync_customer_kiot(data, access_token)
    payload = {
      "code": data.kiot_id,
      "name": data.username,
      "gender": false,
      "contactNumber": data.phone,
      "address": "",
      "email": data.email,
      "comments": "login #{access_token.provider}",
      "branchId": 31669
    }
    KiotViet.add_customer(payload, token_kiot)
  end

  def self.code_kiot
    "KHW#{DateTime.now.to_i}"
  end
end
