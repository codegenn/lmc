class StoreController < ApplicationController
  def index
    @menu = 'store'
  end

  def about
    @menu = 'about'
  end

  def find_us
    @menu = 'findus'
  end
end
