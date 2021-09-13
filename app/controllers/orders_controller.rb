class OrdersController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:new, :create]
  before_action :fundiin_config, only: :create
  before_action :spp_config, only: :create

  def index
    @orders = current_user.orders
  end

  def create
    if current_user
      @order = current_user.orders.new(order_params)
    else
      @order = Order.new(order_params)
    end
    @order.add_line_items_from_cart(@cart)

    if @order.save
      Cart.find_by_code(session[:cart_code]).destroy
      case
      when params["order"]["payment_method"].include?("FUNDIIN")
        respon = pay_fundiin(@order.phone, @order.grand_total, @order.id)
        if respon["code"] == 1
          update_status(@order)
          noti_success(@order)
          redirect_to products_path
        else
          flash[:danger] = @order.errors.full_messages.to_sentence
          render 'carts/show'
        end
      when params["order"]["payment_method"].include?("Shopee pay")
        if check_device.include?("mobile")
          respon = create_order_app_spp(@order.phone, @order.grand_total, @order.id)
          if (respon["errcode"] == 0 && respon["request_id"] == @order.id) ||
              !Rails.env.production? && respon["request_id"].include?("a#{@order.id}")
            redirect_to respon["redirect_url_http"]
          else
            render 'carts/show'
          end
        else
          @respon = spp_qrcode(@order.phone, @order.grand_total, @order.id)
          Rails.logger.info @respon
          if @respon["errcode"] == 0
            render 'carts/spp_qrcode'
          else
            flash[:danger] = @order.errors.full_messages.to_sentence
            render 'carts/show'
          end
        end
      else
        noti_success(@order)
        redirect_to products_path
      end

    else
      flash[:danger] = @order.errors.full_messages.to_sentence
      render 'carts/show'
    end
  end

  private
  def authorize
    unless user_signed_in?
      flash[:danger] = 'You need to sign in'
      redirect_to books_path
    end
  end

  def order_params
    params.require(:order).permit(:first_name, :last_name, :email, :address, :district, :city, :phone, :note, :tracking, :payment_method)
  end

  def fundiin_config
    Fundiin.configure do |config|
      config.private_code = ENV['FUNDIIN_PRIVATE_CODE']
      config.merchant_code = ENV['FUNDIIN_MERCHANT_CODE']
    end
  end

  def spp_config
    client_id = check_device.include?("mobile") ? ENV["SPP_CLIENT_ID_MOBILE"] : ENV["SPP_CLIENT_ID"]
    ShopeePay.configure do |config|
      config.client_id = client_id
    end
  end

  def pay_fundiin(phone, amount, order_id)
    body = {
      :phone_number => phone,
      :amount => amount,
      :shop_id => ENV['FUNDIIN_SHOP_ID'],
      :order_id => order_id
    }

    Fundiin.create_booking_sms(body)
  end

  def spp_qrcode(phone, amount, order_id)
    secret_key = check_device.include?("mobile") ? ENV["SPP_SECRET_KEY_MOBILE"] : ENV["SPP_SECRET_KEY"]
    total_amout = Rails.env.production? ? amount : 1000
    order_id = Rails.env.production? ? order_id : "a#{order_id}"
    expried_at = (Time.now + 15.days).to_i
    body = {
      "request_id": order_id,
      "store_ext_id": ENV["SPP_STORE_EXT_ID"],
      "merchant_ext_id": ENV["SPP_MERCHANT_EXT_ID"],
      "amount": total_amout,
      "additional_info": "",
      "currency": "VND",
      "expiry_time": expried_at,
      "payment_reference_id": order_id
    }

    ShopeePay.create_qr_code(body, Auth.auth_signature(body, secret_key))
  end

  def update_status(order)
    order.status = "Send sms to Fundiin"
    order.save!
  end

  def noti_success(order)
    UserMailer.order_for_user(order).deliver_now if Rails.env.production?
    session[:cart_code] = nil
    flash[:success] = I18n.t('controllers.order.success')
    flash[:pixel] = 'Purchase'
  end

  def create_order_app_spp(phone, amount, order_id)
    secret_key = check_device.include?("mobile") ? ENV["SPP_SECRET_KEY_MOBILE"] : ENV["SPP_SECRET_KEY"]
    total_amout = Rails.env.production? ? amount : 1000
    order_id = Rails.env.production? ? order_id : "a#{order_id}"
    expried_at = (Time.now + 15.days).to_i
    body = {
      "request_id": order_id,
      "store_ext_id": ENV["SPP_STORE_EXT_ID"],
      "merchant_ext_id": ENV["SPP_MERCHANT_EXT_ID"],
      "amount": total_amout,
      "return_url": "https://www.lmcation.com/",
      "platform_type": "mweb",
      "currency": "VND",
      "expiry_time": expried_at,
      "payment_reference_id": order_id,
      "additional_info": ""
    }

    ShopeePay.create_order(body, Auth.auth_signature(body, secret_key))
  end

  def check_device
    agent = request.user_agent
    return "tablet" if agent =~ /(tablet|ipad)|(android(?!.*mobile))/i
    return "mobile" if agent =~ /Mobile/
    return "desktop"
  end
end
