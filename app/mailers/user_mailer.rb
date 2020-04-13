class UserMailer < ApplicationMailer
  def order_for_user(order)
    @order = order
    subj = 'Thanks for Purchase'
    mail(to: @order.email, bcc: 'info@lmcation.com', subject: subj, from: "info@lmcation.com")
  end
end
