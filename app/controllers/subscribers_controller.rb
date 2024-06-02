class SubscribersController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    sub = Subscriber.new
    sub.email = params[:email]
    if sub.save!
      flash[:success] = I18n.t('subscribe_success')
      flash[:pixel] = 'Subscribe'
      redirect_to products_path
    else
      flash[:danger] = @subscriber.errors.full_messages.to_sentence
      redirect_to products_path
    end
  end

  private
  def subscriber_params
    params.require(:subscriber).permit(:email)
  end
end
