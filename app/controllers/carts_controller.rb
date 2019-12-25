class CartsController < ApplicationController
  before_action :validate_cart_id, :set_cart, only: [:show, :update]

  def show
    @line_items = @cart.line_items.includes(:stock)
    @order = Order.new
  end

  def update
    if @cart.update(cart_params)
      notice = 'Update successfully'
    else
      notice = @cart.errors.full_messages.to_sentence
    end
    redirect_to cart_path(@cart.code), notice: notice

    @line_items = @cart.line_items.includes(:stock)
  end

  private
  def set_cart
    if params[:cart]
      @cart = Cart.find_by_code(params[:cart][:id])
    else
      @cart = Cart.find_by_code(params[:id])
    end
  end

  def cart_params
    params.require(:cart).permit(line_items_attributes: [:quantity, :id])
  end

  def validate_cart_id
    if params[:cart] && params[:cart][:id] != session[:cart_code]
      redirect_to products_path, notice: 'Invalid cart'
    elsif params[:cart].nil? && params[:id] != session[:cart_code]
      redirect_to products_path, notice: 'Invalid cart'
    end
  end
end
