class ProductsController < ApplicationController
  before_action :set_product, only: [:show]
  before_action :set_menu

  def index
    category = params[:category]
    check = params[:check]
    query = params[:q]
    if category.present?
      @category = Category.friendly.find(category)
      @products = @category.products.order(out_of_stock: :asc, sort_order: :desc, created_at: :desc)
    elsif check.present?
      @products = Product.send(check.to_sym).order(out_of_stock: :asc, sort_order: :desc, created_at: :desc)
      @check = true
    elsif query
      @at = []
      @products = Product.translation_class.where('title LIKE :search_name OR description LIKE :search_description OR short_description = :short_description',
                                  search_name: "%#{query}%", search_description: "%#{query}%", short_description: "%#{query}%").all.each do |t|
        @at << t.product_id
      end
      if @at.present?
        @products = Product.where(id: @at).main_page
      else
        @products = Product.main_page
        flash[:success] = I18n.t('controllers.search.no_re')
      end
    else
      @products = Product.main_page
    end
  end

  def show
    @product = Product.friendly.find(params[:id])
    @stocks = @product.stocks.group_by(&:size)
    @b_stocks = @product.bottom_stocks
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
