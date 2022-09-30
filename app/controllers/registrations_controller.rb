class RegistrationsController < Devise::RegistrationsController
  before_filter :set_order, only: [:edit]

  def new
    super
  end

  def update
    super
  end

  def create
    super
  end

  private
  def set_order
    @orders = current_user.orders
  end
end
