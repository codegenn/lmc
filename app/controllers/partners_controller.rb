class PartnersController < ApplicationController
  def create
    @partner = Partner.new(email: params[:email])

    if @partner.save
      flash[:success] = 'Thank you for your contact. We will check and contact to you soon'
    else
      flash[:danger] = @partner.errors.full_messages.to_sentence
    end
    redirect_to jobs_path
  end
end
