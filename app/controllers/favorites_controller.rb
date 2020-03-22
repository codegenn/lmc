class FavoritesController < ApplicationController
  before_action :logged_in
  before_action :set_wishlist

  def update
    @product = Product.find(params[:id])
    if @favorite.products.include?(@product)
      @favorite.favorite_products.where(product_id: params[:id]).destroy_all
      flash[:success] = 'Remove successfully'
    else
      @favorite.products << @product
      flash[:success] = 'Add product to wishlist successfully'
    end
  end

  private
  def logged_in
    unless user_signed_in?
      flash[:danger] = 'You need to sign in'
      render :js => "window.location = '#{new_user_session_path}'"
    end
  end

  def set_wishlist
    @favorite = Favorite.find_by_code(session[:fav_code])
    if @favorite.blank?
      @favorite = Favorite.create(user: current_user)
      session[:fav_code] = @favorite.code
    end
  end
end
