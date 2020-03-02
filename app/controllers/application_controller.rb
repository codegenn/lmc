class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_cart
  before_action :set_categories
  before_filter :set_i18n_locale

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    permits = [:first_name, :phone, :last_name]
    devise_parameter_sanitizer.permit(:sign_up, keys: permits)
    devise_parameter_sanitizer.permit(:account_update, keys: permits)
  end

  private
  def set_cart
    @cart = Cart.find_by_code(session[:cart_code])
  end

  def set_i18n_locale
    if params[:locale]
      if I18n.available_locales.include?(params[:locale].to_sym)
        I18n.locale = params[:locale]
      else
        flash.now[:notice] = params[:locale] + ' is not supported'
      end
    end
  end

  def default_url_options
    { :locale => I18n.locale }
  end

  def set_categories
    @cats = Category.all
  end
end
