class MessagesController < ApplicationController
  def create
    @message = Message.new(email: params[:email], question: params[:question])

    if @message.save
      UserMailer.delay.message_for_admin(@message)
      flash[:success] = I18n.t('controllers.message.success')
    else
      flash[:danger] = @message.errors.full_messages.to_sentence
    end
    redirect_to lien_he_path
  end
end
