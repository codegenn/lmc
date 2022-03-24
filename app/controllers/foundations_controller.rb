class FoundationsController < ApplicationController
  include ApplicationHelper
  before_action :set_menu

  def index
    breadcrumb I18n.t("page.menu.foundation"), "#{I18n.locale}/foundations"
    category = params[:category]
    if category.present?
      @cat = true
      @blogs = Foundation.where(category: category)
    else
      @cat = false
      @blogs = Foundation.main_page.flatten.compact.group_by { |d| d[:category] }
    end
  end

  def show
    @blog = Foundation.friendly.find(params[:id])
    meta_data(
        "lmcation.com, lmcation",
        @blog.title,
        Cloudinary::Utils.cloudinary_url(@blog.f_image_url),
        "https://www.lmcation.com/#{I18n.locale.to_s}/foundations/#{@blog.slug}"
    )
  end

  def set_menu
    @menu = 'foundation'
  end
end
