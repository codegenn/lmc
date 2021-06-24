class StoreController < ApplicationController
  include ApplicationHelper
  def index
    @menu = 'store'
    expires_in 3.days, :public => true
    meta_data(
      "lmcation.com, lmcation",
      "Đồ Mặc Nhà - Đồ Ngủ, Gym-to-Swim, Đồ Bơi, Đồ Thể Thao",
      "https://res.cloudinary.com/dbysq36qu/image/upload/v1622280133/main-logo-sm.png",
      "https://www.lmcation.com/#{I18n.locale.to_s}"
    )
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
