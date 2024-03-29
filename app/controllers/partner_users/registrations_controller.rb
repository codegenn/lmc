# frozen_string_literal: true

class PartnerUsers::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super do |resource|
      if resource.errors.any?
        flash["danger"] = flash['danger'].to_a.concat resource.errors.full_messages
        redirect_to new_partner_user_registration_path
        return
      end
    end
  end

  def sign_up_params
    params.require(:partner_user).permit(:email, :password, :password_confirmation, :name, :address, :info, :phone)
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def after_sign_up_error_path_for(resource)
    flash[:error] = resource.errors.full_messages.join(", ")
    render 'signup_failure'
  end
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    # flash[:success] = 'Cảm ơn bạn đã gửi thông tin. Bộ phận phụ trách sẽ liên hệ bạn trong vòng 24-48h làm việc.'
    resource.tracking = "#{DateTime::now().to_time.to_i}#{resource.id}"
    resource.save
    UserMailer.partner(resource).deliver_now if Rails.env.production?
    partners_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
