class StoreController < ApplicationController
  def index
    @menu = 'store'
    expires_in 7.days, :public => true
  end

  def about
    @menu = 'about'
  end

  def find_us
    @menu = 'findus'
  end

  def privacy
  end

  def policy
  end

  def ping
    render :text => "PONG!"
  end
end
