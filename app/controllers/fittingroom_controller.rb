class FittingroomController < ApplicationController
  def index
    meta_data(
      "LMCATION - fitting-room",
      "Đồ Mặc Nhà - Đồ Ngủ, Gym-to-Swim, Đồ Bơi, Đồ Thể Thao",
      "https://res.cloudinary.com/dbysq36qu/image/upload/v1622280133/main-logo-sm.png",
      "https://www.lmcation.com/#{I18n.locale.to_s}",
      "fitting-room"
    )
  end
end
