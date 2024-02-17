class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review, only: [:show, :edit, :update, :respond]

  def index
    @reviews = current_user.business.reviews
  end

  def show
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to reviews_path, notice: 'Review updated successfully.'
    else
      render :edit
    end
  end

  def respond
    # Logic for responding to a review
  end

  private

  def set_review
    @review = current_user.business.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:platform, :rating, :content, :responded)
  end
end
