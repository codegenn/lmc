class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2, :facebook]
  # validates :first_name, presence: true
  # validates :last_name, presence: true
  # validates :phone_number,
  #   uniqueness: true
  # validates :phone,
  #           :presence => {:message => 'Only positive number without spaces are allowed'},
  #           :numericality => true,
  #           :length => { :minimum => 6, :maximum => 15 }
  has_many :orders
  has_one :favorite

  after_create :update_kiot_id

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
    if user
      user
    else
      if access_token.provider == "facebook"
        user = User.new(username: data['name'],
          email: data['email'],
          password: Devise.friendly_token[0,20],
          uid: access_token[:uid],
          provider: access_token[:provider],
          first_name: data["name"].split(" ").last,
          last_name: data["name"].split(" ").first,
          avatar: data["image"],
          phone_number: "",
          phone: 0
        )
        user.save(:validate => false)
      else
        user = User.new(username: data['name'],
            email: data['email'],
            password: Devise.friendly_token[0,20],
            uid: access_token[:uid],
            provider: access_token[:provider],
            first_name: data["first_name"],
            last_name: data["last_name"],
            avatar: data["image"],
            phone: 0,
            phone_number: "",
        )
        user.save(:validate => false)
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
      "contactNumber": "0#{data.phone}",
      "address": "",
      "email": data.email,
      "comments": "login #{access_token.provider}",
      "branchId": 31669
    }
    KiotViet.add_customer(payload, token_kiot)
  end

  
  def update_kiot_id
    unless self.kiot_id.present?
      self.kiot_id = "LMWEB#{self.id}"
      self.save
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  first_name             :string           default(""), not null
#  last_name              :string           default(""), not null
#  phone                  :integer          not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string
#  uid                    :string
#  username               :string
#  avatar                 :string
#  dob                    :datetime
#  code_kiot              :integer
#  kiot_id                :string
#  address                :string
#  phone_number           :string
#  code                   :string
#  role                   :integer
#  status                 :integer          default(0)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
