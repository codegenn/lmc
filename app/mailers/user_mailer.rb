class UserMailer < ApplicationMailer
  def order_for_user(order)
    @order = order
    @payment_method = payment_method(order)
    subj = 'Thanks for Purchase'
    mail(to: @order.email, bcc: 'info@lmcation.com', subject: subj, from: Rails.application.secrets.gmail_email)
  end

  def message_for_admin(message)
    @message = message
    subj = 'You have a new message'
    mail(to: 'info@lmcation.com', subject: subj, from: Rails.application.secrets.gmail_email)
  end

  def payment_method(order)
    if order.payment_method == 'COD'
      return 'Thanh toán khi giao hàng (COD)'
    elsif order.payment_method.include?('FUNDIIN')
      return 'Chuyển Khoản FUNDIIN'
    elsif order.payment_method.include?("Shopee pay")
      return 'Chuyển Khoản Ví ShopeePay'
    elsif order.payment_method.include?("vnpay")
      return 'Thẻ ATM, VISA, MASTER'
    end
  end
end
