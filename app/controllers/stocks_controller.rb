class StocksController < ApplicationController
  def show
    @product = Product.where(id: params[:product_id]).first
    @stocks = Stock.where(size: params[:stock_id], product_id: params[:product_id])
    @selected_stock = @product.stocks.where(size: params[:stock_id], color: params[:color]).first
  end
end
