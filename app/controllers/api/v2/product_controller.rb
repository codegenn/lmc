module Api
  module V2
    class ProductController < ApiController
      def show
        product = Product.find_by(id: params[:id])
        if product
          render json: { id: product.id, title: product.title, price: product.price }, status: :ok
        else
          render json: { error: 'Product not found' }, status: :not_found
        end
      end
    end
  end
end