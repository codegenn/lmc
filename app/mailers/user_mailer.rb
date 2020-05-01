class UserMailer < ApplicationMailer
  def order_for_user(order)
    @order = order
    subj = 'Thanks for Purchase'
    mail(to: @order.email, bcc: 'info@lmcation.com', subject: subj, from: "info@lmcation.com")
  end

  def message_for_admin(message)
    @message = message
    subj = 'You have a new message'
    mail(to: 'info@lmcation.com', subject: subj, from: "info@lmcation.com")
  end
end
