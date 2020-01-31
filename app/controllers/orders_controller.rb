class OrdersController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:new, :create]

  def index
    @orders = current_user.orders
  end

  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(@cart)

    if @order.save
      Cart.find_by_code(session[:cart_code]).destroy
      session[:cart_code] = nil
      redirect_to products_path, notice: 'Thank you for your order'
    else
      flash[:danger] = @order.errors.full_messages.to_sentence
      redirect_to cart_path(@cart.code)
    end
  end

  private
  def authorize
    unless user_signed_in?
      redirect_to books_path, notice: 'You need to sign in'
    end
  end

  def order_params
    params.require(:order).permit(:first_name, :last_name, :email, :address, :district, :city, :phone, :note)
  end
end
