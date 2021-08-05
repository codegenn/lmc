class ProductsController < ApplicationController
  include ApplicationHelper
  before_action :set_product, only: [:show]
  before_action :set_menu
  before_action :set_bread

  def index
    breadcrumb I18n.t("page.menu.shop"), "products"
    @data_bread.push({name: I18n.t("page.menu.shop"), item: "https://www.lmcation.com/#{I18n.locale}/products"})
    category = params[:category]
    check = params[:check]
    query = params[:q]
    @keyword = nil
    if category.present?
      @keyword = I18n.t("keyword_sport") unless category.include?("do-mac-nha-do-ngu")
      # Rails.cache.fetch(cache_key(category)) do
        @category = Category.friendly.find(category)
        @products = @category.products.active.order(out_of_stock: :asc, sort_order: :desc, created_at: :desc)
      # end
      breadcrumb @category.name, "?category=#{@category.slug}"
      @data_bread.push({name: @category.name, item: "https://www.lmcation.com/#{I18n.locale}/products?category=#{@category.slug}"})
    elsif check.present?
      @products = Product.send(check.to_sym).active.order(out_of_stock: :asc, sort_order: :desc, created_at: :desc)
      @check = true
    elsif query
        @at = []
        Product.translation_class.where('title LIKE :search_name OR description LIKE :search_description OR short_description = :short_description',
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
      @products = Product.main_page @cats
    end
    list_bread(@data_bread)
    meta_data(
      "Đồ Mặc Nhà - Đồ Ngủ, Gym-to-Swim, Đồ Bơi, Đồ Thể Thao",
      "Đồ Mặc Nhà - Đồ Ngủ, Gym-to-Swim, Đồ Bơi, Đồ Thể Thao",
      "https://res.cloudinary.com/dbysq36qu/image/upload/v1622280133/main-logo-sm.png",
      "https://www.lmcation.com/#{I18n.locale.to_s}/products",
      @keyword.nil? ? I18n.t("keyword") : @keyword
    )
  end

  def show
    redirect_to products_path if @product.is_hidden
    # Rails.cache.fetch(cache_key(@product.id)) do
      @stocks = @product.stocks.group_by(&:size)
      @b_stocks = @product.bottom_stocks
      @color_images = @product.color_images
      @category = @product.categories.first
      @related_products = @category ? @category.products.sample(4) : Product.all.sample(4)
    # end
    breadcrumb(I18n.t("page.menu.shop"), "https://www.lmcation.com/#{I18n.locale}/products")
    unless @category.nil?
      breadcrumb(@category.name, "https://www.lmcation.com/#{I18n.locale}/products?category=#{@category.slug}")
    end
    breadcrumb(@product.title, "https://www.lmcation.com/#{I18n.locale}/#{@product.slug}")
    @data_bread.push({name: I18n.t("page.menu.shop"), item: "https://www.lmcation.com/#{I18n.locale}/products"})
    @data_bread.push({name: @category.name, item: "https://www.lmcation.com/#{I18n.locale}/products?category=#{@category.slug}"})
    @data_bread.push({name: @product.title, item: "https://www.lmcation.com/#{I18n.locale}/#{@product.slug}"})
    list_bread(@data_bread)
    meta_data(
      @product.title,
      @product.description,
      @product.product_images.first.try(:image_url),
      product_path(@product.slug),
      I18n.t("keyword") << "," << I18n.t("keyword_sport")
    )
  end

  private

  def set_product
    @product = Rails.cache.fetch(cache_key(params[:id])) do
      Product.friendly.find(params[:id])
    end
  end

  def set_bread
  end
  
  def cache_key(key)
    "#{key}_#{I18n.locale}"
  end

  def set_menu
    @menu = 'product'
  end
end

