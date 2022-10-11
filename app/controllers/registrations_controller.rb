class RegistrationsController < Devise::RegistrationsController
  before_filter :set_order, only: [:edit]
  before_action :get_point_kiot, only: :edit

  def new
    super
  end

  def update
    super
  end

  def create
    super
  end

  def get_point_kiot
    @point_kiot = 0
    if user_signed_in? && current_user.kiot_id.present?
      res = KiotViet.get_customers(token, current_user.kiot_id)
      if res.code == 200
        data = JSON.parse(res.body)
        @point_kiot = data["totalPoint"]
      end
    end
  end

  def token
    KiotViet.configure do |config|
      config.client_id = ENV['KIOT_CLIENT_ID']
      config.client_secret = ENV['KIOT_CLIENT_SECRET']
    end
    respon = KiotViet.get_token
    token = respon["access_token"]
    return "Bearer ".concat(token)
  end

  private
  def set_order
    @orders = current_user.orders
  end
end
