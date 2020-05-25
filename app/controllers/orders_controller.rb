class OrdersController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:new, :create]

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
      UserMailer.order_for_user(@order).deliver_now
      session[:cart_code] = nil
      flash[:success] = I18n.t('controllers.order.success')
      flash[:pixel] = 'Purchase'
      redirect_to products_path
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
end
