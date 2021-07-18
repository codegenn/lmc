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
    name = I18n.t("page.menu.about_us")
    item = "https://www.lmcation.com/vi/thoi-trang-ton-vinh-phu-nu"
    @data_bread.push({name: name, item: item})
    list_bread(@data_bread)
    breadcrumb(name, item)
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

  private

  def list_bread(arr_bread)
    list_items = []
    arr_bread.each_with_index do |v, i|
      list_items.push({
        "@type": "ListItem",
        "position": (i+1).to_i,
        "name": v[:name],
        "item": v[:item]
      })
    end

    @datas = {
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      "itemListElement": list_items
    }.to_json
  end
end
