class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, :validate_stock_id,  only: [:create]
  before_action :validate_cart_session, only: [:destroy]
  before_action :set_line_item, only: [:update, :destroy]

  def create
    @line_item = @cart.add_product(@stock)

    if @line_item.save
      flash[:notice] = 'Add product to cart successfully'
    else
      flash[:error] = @line_item.errors.full_messages.to_sentence
    end
  end

  def update
    if @line_item.update(line_item_params)
      notice = 'Update successfully'
    else
      notice = @line_item.errors.full_messages.to_sentence
    end
    redirect_to cart_path(@line_item.cart.code), notice: notice
  end

  def destroy
    LineItem.includes(:cart).where(carts: { code: session[:cart_code] }, line_items: { id: params[:id] }).destroy_all
    redirect_to cart_path(@line_item.cart.code), notice: 'Remove successfully'
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
      redirect_to products_path, notice: 'Cart is not present'
    end
  end

  def validate_stock_id
    @stock = Stock.where(size: params[:size], color: params[:color]).first
    unless @stock
      redirect_to products_path, notice: 'Invalid Product'
    end
  end
end
