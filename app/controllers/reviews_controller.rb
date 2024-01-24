class ReviewsController < ApplicationController
  def create
    @product = Product.find(params[:review][:product_id])

    @review = @product.reviews.new(review_params)
    @review.status = false
    @review.customer_name = current_user.try(:first_name) || 'Lmcation Customer'
    if @review.save
      flash[:success] = 'Review successfully created.'
    end
    redirect_to @product
  end

  private

  def review_params
    params.require(:review).permit(:customer_name, :content, :star_rating, :status)
  end
end
