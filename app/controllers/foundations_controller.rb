class FoundationsController < ApplicationController
  def index
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
    @blog = Foundation.find_by_id(params[:id])
  end
end
