class SubscribersController < ApplicationController
  def create
    @subscriber = Subscriber.new(subscriber_params)

    if @subscriber.save
      flash[:success] = 'Thank you for your subscriber'
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
