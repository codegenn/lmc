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

  def update_resource(resource, params)
    if current_user.provider == "facebook" || current_user.provider == "google_oauth2"
      params.delete("current_password")
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
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

  protected

  def after_update_path_for(resource)
    edit_user_registration_path(resource)
  end

  def after_sign_up_path_for(resource)
    sync_customer_kiot(resource)
    edit_user_registration_path(resource)
  end

  def after_sign_in_path_for(resource)
    edit_user_registration_path(resource)
  end
  
  def after_inactive_sign_up_path_for(resource)
    new_user_registration_path(resource)
  end

  private

  def account_update_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :phone_number, :current_password, :address)
  end

  def set_order
    @orders = current_user.orders
  end

  def token_kiot
    KiotViet.configure do |config|
      config.client_id = ENV['KIOT_CLIENT_ID']
      config.client_secret = ENV['KIOT_CLIENT_SECRET']
    end
    respon = KiotViet.get_token
    token = respon["access_token"]
    return "Bearer ".concat(token)
  end

  def sync_customer_kiot(data)
    payload = {
      "code": data.kiot_id,
      "name": data.username,
      "gender": false,
      "contactNumber": "0#{data.phone}",
      "address": "",
      "email": data.email,
      "comments": "Login form",
      "branchId": 31669
    }
    KiotViet.add_customer(payload, token_kiot)
  end
end
