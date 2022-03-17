class StoreController < ApplicationController
  include ApplicationHelper
  require 'json'

  def index
    # Rails.cache.fetch(cache_key("store")) do
      @menu = 'store'
      expires_in 3.days, :public => true
      file = File.open("app/assets/file/discount_config.txt")
      file_data = file.read
      data = JSON.parse(file_data)
      @text = data["text"]
      @amount = data["discount"]
      meta_data(
        "lmcation.com, lmcation",
        "Đồ Mặc Nhà - Đồ Ngủ, Gym-to-Swim, Đồ Bơi, Đồ Thể Thao",
        "https://res.cloudinary.com/dbysq36qu/image/upload/v1622280133/main-logo-sm.png",
        "https://www.lmcation.com/#{I18n.locale.to_s}"
      )
    # end
  end

  def about
    name = I18n.t("page.menu.about_us")
    item = "https://www.lmcation.com/#{I18n.locale}/thoi-trang-ton-vinh-phu-nu"
    @data_bread.push({name: name, item: item})
    list_bread(@data_bread)
    breadcrumb(name, item)
    @menu = 'about'
  end

  def find_us
    name = I18n.t("page.menu.find_us")
    item = "https://www.lmcation.com/#{I18n.locale}/lien-he"
    @data_bread.push({name: name, item: item})
    list_bread(@data_bread)
    breadcrumb(name, item)
    @menu = 'findus'
  end

  def privacy
    name = I18n.t("page.privacy.privacy")
    item = "https://www.lmcation.com/#{I18n.locale}/privacy"
    @data_bread.push({name: name, item: item})
    list_bread(@data_bread)
    breadcrumb(name, item)
  end

  def privacy_buy
    name = I18n.t("page.privacy_buy.title")
    item = "https://www.lmcation.com/vi/huong-dan-mua-hang"
    @data_bread.push({name: name, item: item})
    list_bread(@data_bread)
    breadcrumb(name, item)
  end

  def privacy_payment
    name = I18n.t("page.privacy_payment.title")
    item = "https://www.lmcation.com/vi/quy-dinh-thanh-toan-va-can-chuyen"
    @data_bread.push({name: name, item: item})
    list_bread(@data_bread)
    breadcrumb(name, item)
  end

  def policy
    name = I18n.t("page.index.return")
    item = "https://www.lmcation.com/#{I18n.locale}/policy"
    @data_bread.push({name: name, item: item})
    list_bread(@data_bread)
    breadcrumb(name, item)
  end

  def ping
    render :text => "PONG!"
  end

  def cache_key(key)
    "#{key}_#{I18n.locale}"
  end
end
