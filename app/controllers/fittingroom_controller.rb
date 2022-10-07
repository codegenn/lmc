class FittingroomController < ApplicationController
  before_action :authenticate_user!
  def index
    if current_user.email == "lmcation-demo@gmail.com" && current_user.username == "LMCATION"
      return
    else
      redirect_to products_path
    end
  end
end
  