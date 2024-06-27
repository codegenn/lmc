class FoundationsController < ApplicationController
  include ApplicationHelper
  before_action :set_menu

  def index
    breadcrumb I18n.t("page.menu.foundation"), "#{I18n.locale}/foundations"
    category = params[:category]
    if category.present?
      @cat = true
      @blogs = Foundation.where(category: category).order(created_at: :desc)
    else
      @cat = false
      grouped_data = Foundation.main_page.flatten.compact.group_by { |d| d[:category] }

      ordered_data = grouped_data.transform_values do |array|
        array.sort_by { |d| d[:created_at] }.reverse
      end

      @blogs = ordered_data
    end
  end

  def show
    @blog = Foundation.friendly.find(params[:id])
    meta_data(
        @blog.title,
        @blog.title,
        Cloudinary::Utils.cloudinary_url(@blog.f_image_url),
        "https://www.lmcation.com/#{I18n.locale.to_s}/foundations/#{@blog.slug}"
    )
  end

  def set_menu
    @menu = 'foundation'
  end
end
