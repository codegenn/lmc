class SubscribersController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    sub = Subscriber.new
    sub.email = params[:email]
    if sub.valid? && sub.save!
      flash[:success] = I18n.t('subscribe_success')
      flash[:pixel] = 'Subscribe'
      redirect_to products_path
    else
      flash[:success] = I18n.t('subscribe_success')
      redirect_to products_path
    end
  end

  PHONE_REGEX = /\A\d{9,11}\z/

  def create_phone
    sub = Subscriber.new
    if PHONE_REGEX.match?(sub.phone)
      sub.save

      if Rails.env.production?
        UserMailer.message_for_admin_phone(sub.phone).deliver_now
      end

      flash[:success] = I18n.t('subscribe_success_phone')
      flash[:pixel] = 'Subscribe'
    else
      flash[:success] = I18n.t('subscribe_success_phone')
    end
    redirect_to products_path
  end

  private
  def subscriber_params
    params.require(:subscriber).permit(:email)
  end
end
