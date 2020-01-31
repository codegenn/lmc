class StoreController < ApplicationController
  def index
    @menu = 'store'
    @cats = Category.all
  end

  def about
    @menu = 'about'
  end

  def find_us
    @menu = 'findus'
  end
end
