class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @business = current_user.business
    @reviews = @business.reviews
    @campaigns = @business.campaigns
    @email_templates = @business.emailtemplates

    # Calculate reviews in the last 30 days
    @reviews_last_30_days_count = @reviews.where('created_at >= ?', 30.days.ago).count

    # Group reviews by month and count them
    # @reviews = @business.reviews.where('created_at >= ?', 1.year.ago)
    @reviews_by_month = @reviews.group_by { |review| review.created_at.beginning_of_month.strftime("%B %Y") }
    @reviews_by_month.transform_values!(&:count)

  end
end
