class OrdersController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:new, :create]
  before_action :fundiin_config, only: :create
  before_action :spp_config, only: :create
  after_action :update_data_user, only: :create

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
          redirect_to products_path
        end
      when params["order"]["payment_method"].include?("Shopee pay")
        if check_device.include?("mobile")
          respon = create_order_app_spp(@order.phone, @order.grand_total, @order.id)
          Rails.logger.info("respon: #{respon}")
          if (respon["errcode"] == 0 && respon["request_id"].to_i == @order.id) ||
              !Rails.env.production? && respon["request_id"].include?("a#{@order.id}")
            redirect_to respon["redirect_url_http"]
          else
            redirect_to products_path
          end
        else
          @respon = spp_qrcode(@order.phone, @order.grand_total, @order.id)
          Rails.logger.info "respon: #{@respon}"
          if !@respon.body.nil? && @respon["errcode"] == 0
            render 'carts/spp_qrcode'
          else
            flash[:danger] = @order.errors.full_messages.to_sentence
            redirect_to products_path
          end
        end
      when params["order"]["payment_method"].include?("vnpay")
        vnp_url = create_url_vnpay(@order.grand_total, @order.id)
        redirect_to vnp_url
      when params["order"]["payment_method"].include?("momo")
        render 'carts/momo_qrcode'
      else
        noti_success(@order)
        redirect_to products_path
      end
    else
      flash[:danger] = @order.errors.full_messages.to_sentence
      render 'carts/show'
    end
  end

  def fallback
    if checksum_valid!
      if params["vnp_ResponseCode"] == "00"
        flash[:success] = I18n.t('controllers.order.success')
        redirect_to products_path
      else
        # flash[:error] = t('.payment_failed')
        redirect_to products_path
      end
    else
      # flash[:error] = t('.payment_failed')
      redirect_to products_path
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
    params.require(:order).permit(:first_name, :last_name, :email, :address, :district, :city, :phone, :note, :tracking, :payment_method, :note)
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
    total_amout = Rails.env.production? ? amount*100 : 1000
    order_id = Rails.env.production? ? order_id : "a#{order_id}"
    expried_at = (Time.now + 15.days).to_i
    body = {
      "request_id": order_id.to_s,
      "store_ext_id": ENV["SPP_STORE_EXT_ID"],
      "merchant_ext_id": ENV["SPP_MERCHANT_EXT_ID"],
      "amount": total_amout.to_i,
      "additional_info": "",
      "currency": "VND",
      "expiry_time": expried_at,
      "payment_reference_id": order_id.to_s
    }
    Rails.logger.info "body: #{body}"
    Rails.logger.info "signature: #{Auth.auth_signature(body, secret_key)}"
    Rails.logger.info "secret_key: #{secret_key}"

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
    Rails.logger.info("device: #{check_device}")
    secret_key = check_device.include?("mobile") ? ENV["SPP_SECRET_KEY_MOBILE"] : ENV["SPP_SECRET_KEY"]
    total_amout = Rails.env.production? ? amount*100 : 1000
    order_id = Rails.env.production? ? order_id : "a#{order_id}"
    expried_at = (Time.now + 15.days).to_i
    body = {
      "request_id": order_id.to_s,
      "store_ext_id": ENV["SPP_STORE_EXT_ID"],
      "merchant_ext_id": ENV["SPP_MERCHANT_EXT_ID"],
      "amount": total_amout.to_i,
      "return_url": "https://www.lmcation.com/",
      "platform_type": "mweb",
      "currency": "VND",
      "expiry_time": expried_at,
      "payment_reference_id": order_id.to_s,
      "additional_info": ""
    }

    ShopeePay.create_order(body, Auth.auth_signature(body, secret_key))
  end

  def create_url_vnpay(amount, order_id)
    uri = Addressable::URI.new
    tmn_code = "LM000001"
    total_amout = Rails.env.production? ? amount*100 : 100000000
    order_id = Rails.env.production? ? order_id : "a#{order_id}"
    created_at = Time.now.to_i
    uri = "https://www.lmcation.com"
    url = "#{uri}/#{I18n.locale}/vnpay-fallback"
    input_data = {
      "vnp_Amount" => total_amout.to_i,
      "vnp_Command" => "pay",
      "vnp_CreateDate" => DateTime.current.strftime("%Y%m%d%H%M%S"),
      "vnp_CurrCode" => "VND",
      "vnp_IpAddr" => "0.0.0.0",
      "vnp_Locale" => "vn",
      "vnp_OrderInfo" => "HD: #{order_id}",
      "vnp_ReturnUrl" => url,
      "vnp_TmnCode" => tmn_code,
      "vnp_TxnRef" => order_id,
      "vnp_Version" => "2.0.0",
    }

    original_data = input_data.map do |key, value|
      "#{key}=#{value}"
    end.join("&")
    original_data += "&vnp_SecureHash=#{VNPay.auth_signature(original_data, ENV["VNP_HASH_SECRET"])}"
    url = VNPay.create_url(original_data)

    return url
  end

  def check_device
    agent = request.user_agent
    return "tablet" if agent =~ /(tablet|ipad)|(android(?!.*mobile))/i
    return "mobile" if agent =~ /Mobile/
    return "desktop"
  end

  def checksum_valid!
    vnp_secure_hash = params["vnp_SecureHash"]
    data = response_params.to_h.map do |key, value|
      "#{key}=#{value}"
    end.join("&")

    secure_hash = VNPay.auth_signature(data, ENV["VNP_HASH_SECRET"])
    vnp_secure_hash == secure_hash
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

  def update_data_user
    if user_signed_in?
      sync_update_customer_kiot(current_user)
    elsif User.find_by(email: @order.email).present?
      user = User.find_by(email: @order.email)
      @order.update(user_id: user.id)
    elsif !user_signed_in?
      user_name = "#{@order.first_name} #{@order.last_name}"
      user = User.new(username: user_name,
            email: @order.email,
            first_name: @order.first_name,
            last_name: @order.last_name,
            phone: @order.phone,
      )
      user.save(:validate => false)
      @order.update(user_id: user.id)
      sync_add_customer_kiot(user)
    end
    # res = @order.sync_order_kiot
    # @order.update(sync_kiot: (res.code == 200))
  end

  def sync_update_customer_kiot(data)
    address = "#{@order.address} #{@order.district} #{@order.city}"
    payload = {
      "name": data.username,
      "gender": false,
      "contactNumber": data.phone,
      "address": address,
      "email": data.email,
      "comments": "Sign up with order",
      "branchId": 31669
    }
    KiotViet.update_customer(payload, token_kiot, data.kiot_id)
  end

  def sync_add_customer_kiot(data)
    address = "#{@order.address} #{@order.district} #{@order.city}"
    payload = {
      "code": data.kiot_id,
      "name": data.username,
      "gender": false,
      "contactNumber": "0#{data.phone}",
      "address": address,
      "email": data.email,
      "comments": "Sign up with order",
      "branchId": 31669
    }
    KiotViet.add_customer(payload, token_kiot)
  end

  def response_params
    params.permit("vnp_Amount", "vnp_BankCode", "vnp_BankTranNo", "vnp_CardType", "vnp_OrderInfo", "vnp_PayDate", "vnp_ResponseCode", "vnp_TmnCode", "vnp_TransactionNo", "vnp_TxnRef")
  end
end
