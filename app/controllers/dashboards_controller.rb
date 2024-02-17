class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @business = current_user.business
    @reviews = @business.reviews
    @campaigns = @business.campaigns
    # Add more instance variables as needed for your dashboard
  end
end
