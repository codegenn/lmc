class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_i18n_locale
  before_action :set_cart
  before_action :set_fav
  before_action :set_categories

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    permits = [:first_name, :phone, :last_name]
    devise_parameter_sanitizer.permit(:sign_up, keys: permits)
    devise_parameter_sanitizer.permit(:account_update, keys: permits)
  end

  private
  def set_cart
    cart_code = session[:cart_code]
    @cart = cart_code.present? ? Cart.find_by_code(cart_code) : nil
  end

  def set_fav
    fav_code = session[:fav_code]
    @favorite = fav_code.present? ? Favorite.find_by_code(fav_code) : nil
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
    # @cats = Category.all
    cats = Rails.cache.fetch("categories") do
      ActiveRecord::Base.connection.execute(<<-QS
        SELECT c.id, c.category_image_file_name, c.category_image_content_type, c.category_image_file_size,
          c.category_image_updated_at, c.slug, ct.name, ct.description
        FROM categories c
        LEFT JOIN category_translations ct ON ct.category_id = c.id AND ct.locale='#{I18n.locale.to_s}'
        ORDER BY sort_order ASC
        QS
      ).as_json
    end
    
    @cats = Rails.cache.fetch("categories_arr") do
      cats.map do |cat|
        _cat_tmp = Category.new(
          :id => cat['id'],
          :category_image_file_name => cat['category_image_file_name'],
          :category_image_content_type => cat['category_image_content_type'],
          :category_image_updated_at => cat['category_image_updated_at'],
          :category_image_file_size=>cat['category_image_file_size'],
        )
        pap = Paperclip::Attachment.new :category_image, _cat_tmp

        cat['cate_image_url'] = pap.url
        cat
      end
    end
  end
end
