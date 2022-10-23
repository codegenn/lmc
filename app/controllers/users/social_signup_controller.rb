class Users::SocialSignupController < UsersController
 
  def create
    super do |resource|
      binding.pry
      # If SNS account doesn't have associated email, user need to verify email.
      # Encrypted password's presence is required to authenticate user by other micro-services.
      # resource.password = Devise.friendly_token[8, 20]
      # resource.skip_confirmation! if @sns_email
      # resource.social_credentials.build(provider: sns_auth["provider"], uid: sns_auth["uid"])
    end
  end
end