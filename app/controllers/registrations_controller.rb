class RegistrationsController < Devise::RegistrationsController
  before_filter :set_order, only: [:edit]

  private
  def set_order
    @orders = current_user.orders
  end
end
