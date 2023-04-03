class PartnersController < ApplicationController
  before_filter :authenticate_user!, except: [ :index, :sign_up, :create, :sign_in]

  def index
    @jobs = Job.all
  end

  def sign_up
  end

  def sign_in
  end

  def create
    @partner = User.new(partner_params)

    if @partner.save
      flash[:success] = 'Thank you for your contact. We will check and contact to you soon'
    else
      flash[:danger] = @partner.errors.full_messages.to_sentence
    end
    redirect_to partners_path
  end

  def admin
    @products = Product.limit(3)
  end

  private

  def partner_params
    params.require(:user).permit(:email, :password, :password_confirmation, :phone, :name, :address, :code).merge(role: 1)
  end
end
