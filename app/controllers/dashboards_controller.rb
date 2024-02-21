class DashboardsController < ApplicationController
  before_action :authenticate_user!
  require 'net/http'
  require 'uri'
  require 'json'

  def show
    @business = current_user.business
    @reviews = @business.reviews
    @campaigns = @business.campaigns
    @email_templates = @business.emailtemplates

    # Calculate reviews in the last 30 days
    @reviews_last_30_days_count = @reviews.where('created_at >= ?', 30.days.ago).count

    # Group reviews by month and count them
    @reviews_by_month = @reviews.group_by { |review| review.created_at.beginning_of_month.strftime("%B %Y") }
    @reviews_by_month.transform_values!(&:count)

    # Fetch Google Business reviews using the Google Places API
    google_api_key = ENV['GOOGLE_API_KEY'] # Use the environment variable for the API key
    @google_reviews = fetch_google_reviews(google_api_key, @business.google_place_id) if @business.google_place_id
  end

  private

  def fetch_google_reviews(api_key, place_id)
    base_uri = "https://maps.googleapis.com/maps/api/place/details/json"
    uri = URI("#{base_uri}?place_id=#{place_id}&fields=reviews&key=#{api_key}")
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      body = JSON.parse(response.body)
      if body["status"] == "OK" && body["result"]["reviews"]
        return body["result"]["reviews"]
      else
        Rails.logger.error "Error fetching Google reviews: #{body['error_message']}"
      end
    else
      Rails.logger.error "HTTP Request to Google Places API failed: #{response.message}"
    end

    []
  end
end
