class CartsController < ApplicationController
  before_action :validate_cart_id, :set_cart, only: [:show, :update]
  before_action :fundiin_cart, only: :show

  def show
    @locale = params[:locale]
    flash[:pixel] = "InitiateCheckout"
    @line_items = @cart.line_items.includes(:stock)
    last_order = Order.last
    id = last_order ?  last_order.id : 0
    @order = Order.new(tracking: "#{DateTime::now().to_time.to_i}#{id + 1}")
  end

  def update
    if @cart.update(cart_params)
      flash[:success] = I18n.t('controllers.line_items.success_update')
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
    params.require(:cart).permit(:voucher_code, line_items_attributes: [:quantity, :id, :_destroy])
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

  def fundiin_cart
    data = HTTParty.get("https://fundiin-asset.s3.ap-southeast-1.amazonaws.com/merchant/payment_item.json")
    @body = JSON.parse(data.body)
  end
end
