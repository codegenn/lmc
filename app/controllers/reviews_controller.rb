class ReviewsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @product = Product.find(params[:review][:product_id])

    @review = @product.reviews.new(review_params)
    @review.status = false
    unless params[:review][:customer_name].present?
      @review.customer_name = current_user.try(:first_name) || 'Lmcation Customer'
    end

    if params[:review][:review_images].present?
      params[:review][:review_images].each do |image|
        @review.review_images.build(pimage: image)
      end
    end

    if @review.save
      UserMailer.user_review(@review).deliver_now if Rails.env.production?
      flash[:success] = 'Review successfully created.'
    end
    redirect_to @product
  end

  private

  def review_params
    params.require(:review).permit(:customer_name, :email, :content, :star_rating, :status)
  end
end
