class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, :validate_stock_id,  only: [:create]
  before_action :validate_cart_session, only: [:destroy]
  before_action :set_line_item, only: [:update, :destroy]

  def create
    if @stock
      @line_item = @cart.add_product(@stock, @bstock, params[:quantity])

      if @line_item.save
        flash[:success] = I18n.t('controllers.line_items.success')
      else
        flash[:danger] = @line_item.errors.full_messages.to_sentence
      end
    else
      flash[:danger] = I18n.t('controllers.line_items.select_sc')
    end
  end

  def update
    if @line_item.update(line_item_params)
      flash[:success] = I18n.t('controllers.line_items.success_update')
    else
      flash[:danger] = @line_item.errors.full_messages.to_sentence
    end
    redirect_to cart_path(@line_item.cart.code)
  end

  def destroy
    line = LineItem.includes(:cart).where(carts: { code: session[:cart_code] }, line_items: { id: params[:id] }).first
    if line.quantity == 1
      line.destroy
    else
      line.update(quantity: line.quantity - 1)
    end
    flash[:success] = I18n.t('controllers.line_items.success_remove')
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
      flash[:danger] = I18n.t('controllers.line_items.cart_not_present')
      redirect_to products_path
    end
  end

  def validate_stock_id
    @product = Product.where(id: params[:product_id]).first
    @stock = @product.stocks.where(color: params[:color]).first
    # @stock = @product.stocks.where(size: params[:size], color: params[:color]).first
    @bstock = @product.bottom_stocks.where(size: params[:b_size]).first
  end
end
