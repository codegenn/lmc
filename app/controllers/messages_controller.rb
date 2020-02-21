class MessagesController < ApplicationController
  def create
    @message = Message.new(email: params[:email], question: params[:question])

    if @message.save
      flash[:success] = 'Thank you for your contact. We will check and contact to you soon'
    else
      flash[:danger] = @message.errors.full_messages.to_sentence
    end
    redirect_to store_find_us_path
  end
end
