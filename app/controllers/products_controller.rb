class ProductsController < ApplicationController
  before_action :set_product, only: [:show]
  before_action :set_menu

  def index
    category = params[:category]
    check = params[:check]
    if category.present?
      category = Category.find_by_id(category)
      @products = category.products
    elsif check.present?
      @products = Product.send(check.to_sym)
    else
      @products = Product.all
    end
  end

  def show
    @product = Product.find_by_id(params[:id])
    @stocks = @product.stocks
    @category = @product.categories.first
    @related_products = @category.products.sample(4)
  end

  private
  def set_product
    @product = Product.find_by_id(params[:id])
  end

  def set_menu
    @menu = 'product'
  end
end
