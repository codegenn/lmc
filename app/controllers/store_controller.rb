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
    breadcrumb I18n.t("page.menu.about_us"), thoi_trang_ton_vinh_phu_nu_path.to_s
    @menu = 'about'
  end

  def find_us
    breadcrumb I18n.t("page.menu.find_us"), lien_he_path.to_s
    @menu = 'findus'
  end

  def privacy
    breadcrumb I18n.t("page.privacy.privacy"), privacy_path.to_s
  end

  def policy
    breadcrumb I18n.t("page.index.return"), policy_path.to_s
  end

  def ping
    render :text => "PONG!"
  end
end
