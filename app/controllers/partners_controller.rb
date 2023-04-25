class PartnersController < ApplicationController
  before_filter :authenticate_partner_user!, except: [ :index, :sign_up, :sign_in, :check_info]

  def index
    @jobs = Job.all
  end

  def sign_up
  end

  def sign_in
    @partner_user ||= PartnerUser.new
  end

  # def create
  #   @partner = User.new(partner_params)

  #   if @partner.save
  #     flash[:success] = 'Cảm ơn bạn đã gửi thông tin. Bộ phận phụ trách sẽ liên hệ bạn trong vòng 24-48h làm việc.'
  #   else
  #     flash[:danger] = @partner.errors.full_messages.to_sentence
  #   end
  #   redirect_to partners_path
  # end

  def admin
    @products = Product.limit(3)
  end

  def check_info
    if params[:tracking].present? || params[:commit].present?
      @partner_user = PartnerUser.find_by(tracking: params[:tracking])
    else
      flash[:danger] = 'Invalid User'
      redirect_to partners_path
    end
  end

  private

  def partner_params
    params.require(:user).permit(:email, :password, :password_confirmation, :phone, :name, :address, :code).merge(role: 1)
  end
end
