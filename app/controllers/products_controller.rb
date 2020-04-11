class ProductsController < ApplicationController
  before_action :set_product, only: [:show]
  before_action :set_menu

  def index
    category = params[:category]
    check = params[:check]
    if category.present?
      @category = Category.friendly.find(category)
      @products = @category.products
    elsif check.present?
      @products = Product.send(check.to_sym)
    else
      @products = Product.all
    end
  end

  def show
    @product = Product.friendly.find(params[:id])
    @stocks = @product.stocks.group_by(&:size)
    @size_colors = []
    @color_images = @product.color_images
    @category = @product.categories.first
    @related_products = @category ? @category.products.sample(4) : Product.all.sample(4)
  end

  private
  def set_product
    @product = Product.find_by_id(params[:id])
  end

  def set_menu
    @menu = 'product'
  end
end
