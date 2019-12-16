class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def index
    # @products_data = Book::IndexCachier.fetch_products(page: params[:page], per_page: params[:per_page])
    @products = Product.all
  end

  def show
    @product = Product.find_by_id(params[:id])
  end

  private
  def set_product
    @product = Product.find_by_id(params[:id])
  end
end
