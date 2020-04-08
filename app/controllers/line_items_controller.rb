class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, :validate_stock_id,  only: [:create]
  before_action :validate_cart_session, only: [:destroy]
  before_action :set_line_item, only: [:update, :destroy]

  def create
    if @stock
      @line_item = @cart.add_product(@stock)

      if @line_item.save
        flash[:success] = 'Add product to cart successfully'
      else
        flash[:danger] = @line_item.errors.full_messages.to_sentence
      end
    else
      flash[:danger] = 'Please select size and color'
    end
  end

  def update
    if @line_item.update(line_item_params)
      flash[:success] = 'Update successfully'
    else
      flash[:danger] = @line_item.errors.full_messages.to_sentence
    end
    redirect_to cart_path(@line_item.cart.code)
  end

  def destroy
    LineItem.includes(:cart).where(carts: { code: session[:cart_code] }, line_items: { id: params[:id] }).destroy_all
    flash[:success] = 'Remove successfully'
    redirect_to cart_path(@line_item.cart.code)
  end

  private
  def set_line_item
    @line_item = LineItem.find(params[:id])
  end

  def line_item_params
    params.require(:line_item).permit(:quantity)
  end

  def validate_cart_session
    if !session[:cart_code].present?
      flash[:danger] = 'Cart is not present'
      redirect_to products_path
    end
  end

  def validate_stock_id
    @product = Product.where(id: params[:product_id]).first
    @stock = @product.stocks.where(size: params[:size], color: params[:color]).first
  end
end
