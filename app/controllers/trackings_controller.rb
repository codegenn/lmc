class TrackingsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:new, :create]

  def index
    @order = params[:tracking] ? Order.where(tracking: params[:tracking]).first : nil
  end
end
