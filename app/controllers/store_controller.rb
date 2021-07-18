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
    breadcrumb I18n.t("page.menu.about_us"), "https://www.lmcation.com/vi/thoi-trang-ton-vinh-phu-nu"
    @menu = 'about'
  end

  def find_us
    breadcrumb I18n.t("page.menu.find_us"), "https://www.lmcation.com/vi/lien-he"
    @menu = 'findus'
  end

  def privacy
    breadcrumb I18n.t("page.privacy.privacy"), "https://www.lmcation.com/vi/privacy"
  end

  def policy
    breadcrumb I18n.t("page.index.return"), "https://www.lmcation.com/vi/policy"
  end

  def ping
    render :text => "PONG!"
  end
end
