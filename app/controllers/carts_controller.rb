class CartsController < ApplicationController
  before_action :validate_cart_id, :set_cart, only: [:show, :update]

  def show
    @line_items = @cart.line_items.includes(:stock)
    @order = Order.new(tracking: "#{DateTime::now().to_time.to_i}#{Order.last.id + 1}")
  end

  def update
    if @cart.update(cart_params)
      flash[:success] = 'Update successfully'
    else
      flash[:danger] = @cart.errors.full_messages.to_sentence
    end
    redirect_to cart_path(@cart.code)

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
    params[:cart][:line_items_attributes].each do |line_items, l_params|
      if l_params[:quantity].to_i == 0
        params[:cart][:line_items_attributes][line_items][:_destroy] = true
      end
    end
    params.require(:cart).permit(line_items_attributes: [:quantity, :id, :_destroy])
  end

  def validate_cart_id
    if params[:cart] && params[:cart][:id] != session[:cart_code]
      flash[:danger] = 'Invalid cart'
      redirect_to products_path
    elsif params[:cart].nil? && params[:id] != session[:cart_code]
      flash[:danger] = 'Invalid cart'
      redirect_to products_path
    end
  end
end
