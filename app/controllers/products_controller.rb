class ProductsController < ApplicationController
  include ApplicationHelper
  before_action :set_product, only: [:show]
  before_action :set_menu
  before_action :set_bread

  def index
    category = params[:category]
    check = params[:check]
    query = params[:q]
    @keyword = nil
    if category.present?
      @keyword = I18n.t("keyword_sport") unless category.include?("do-mac-nha-do-ngu")
      @category = Category.friendly.find(category)
      @products = @category.products.active.order(out_of_stock: :asc, sort_order: :desc, created_at: :desc)
      breadcrumb @category.name, "#{I18n.locale}/products/?category=#{@category.name}"
    elsif check.present?
      @products = Product.send(check.to_sym).active.order(out_of_stock: :asc, sort_order: :desc, created_at: :desc)
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
      @products = Product.main_page @cats
    end

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
    @stocks = @product.stocks.group_by(&:size)
    @b_stocks = @product.bottom_stocks
    @color_images = @product.color_images
    @category = @product.categories.first
    @related_products = @category ? @category.products.sample(4) : Product.all.sample(4)
    breadcrumb @category.name, "#{I18n.locale}/products/?category=#{@category.name}"
    breadcrumb @product.title, "#{I18n.locale}/products/#{@product.title}"
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
    @product = Product.friendly.find(params[:id])
  end

  def set_bread
    breadcrumb I18n.t("page.menu.shop"), "#{I18n.locale}/products"
  end

  def set_menu
    @menu = 'product'
  end
end
