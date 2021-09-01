class OrdersController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:new, :create]
  before_action :fundiin_config, only: :create

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
      if params["order"]["payment_method"].include?("FUNDIIN")
        respon = pay_fundiin(@order.phone, @order.grand_total, @order.id)
        if respon["code"] == 1
          update_status(@order)
          noti_success(@order)
          render 'carts/fundiin'
        else
          flash[:danger] = @order.errors.full_messages.to_sentence
          render 'carts/show'
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

  def pay_fundiin(phone, amount, order_id)
    body = {
      :phone_number => phone,
      :amount => amount,
      :shop_id => ENV['FUNDIIN_SHOP_ID'],
      :order_id => order_id
    }

    Fundiin.create_booking_sms(body)
  end

  def update_status(order)
    order.status = "Send sms to Fundiin"
    order.save!
  end

  def noti_success(order)
    # UserMailer.order_for_user(order).deliver_now
    session[:cart_code] = nil
    flash[:success] = I18n.t('controllers.order.success')
    flash[:pixel] = 'Purchase'
  end
end
