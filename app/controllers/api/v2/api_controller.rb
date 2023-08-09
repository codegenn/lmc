module Api
  module V2
    class ApiController < ActionController::Base
      
      def product
        flash[:success] = I18n.t('controllers.order.success')
        redirect_to products_path
      end
    end
  end
end