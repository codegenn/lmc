# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    generic_callback("facebook")
  end

  def google_oauth2
    generic_callback( "google_oauth2")
  end

  def generic_callback(provider)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if !@user&.address?
      render template: "users/social_signup/new", layout: "basic_simple_header"
    end

    if @user
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
      return
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to new_user_registration_url
  end
end
