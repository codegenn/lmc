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
    if params[:cart][:voucher_code].present?
      voucher_code = params[:cart][:voucher_code]
      total_price = @cart.total_price

      if valid_voucher?(voucher_code, "200k mbs 400k") && !validate_voucher(voucher_code, total_price, "200k mbs 400k", 400000)
        flash[:danger] = I18n.t('voucher.v200')
        return redirect_to cart_path(@cart.code)
      elsif valid_voucher?(voucher_code, "500k mbs 900k") && !validate_voucher(voucher_code, total_price, "500k mbs 900k", 900000)
        flash[:danger] = I18n.t('voucher.v500')
        return redirect_to cart_path(@cart.code)
      end
    end

    if @cart.update(cart_params)
      if params[:cart][:voucher_code].present?
        voucher_code = params[:cart][:voucher_code]
        total_price = @cart.total_price
        if valid_voucher?(voucher_code, "200k mbs 400k") && !validate_voucher(voucher_code, total_price, "200k mbs 400k", 400000)
          flash[:danger] = I18n.t('voucher.v200')
          @cart.update(voucher_code: nil)
          return redirect_to cart_path(@cart.code)
        elsif valid_voucher?(voucher_code, "500k mbs 900k") && !validate_voucher(voucher_code, total_price, "500k mbs 900k", 900000)
          flash[:danger] = I18n.t('voucher.v500')
          @cart.update(voucher_code: nil)
          return redirect_to cart_path(@cart.code)
        end
      end

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

  def validate_voucher(voucher_code, total_price, discount_price, min_price, max_price = nil)
    voucher = Voucher.find_by(code: voucher_code)

    if max_price.nil?
      return voucher && voucher.voucher_type.include?(discount_price) && total_price >= min_price
    else
      return voucher && voucher.voucher_type.include?(discount_price) && (total_price >= min_price && total_price < max_price)
    end
  end

  def valid_voucher?(code, voucher_type)
    voucher = Voucher.find_by(code: code)
    voucher&.voucher_type&.include?(voucher_type)
  end
end
