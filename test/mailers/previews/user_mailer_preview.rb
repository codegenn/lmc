# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def order_for_user
    UserMailer.order_for_user(Order.last)
  end
end
