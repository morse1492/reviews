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

    # Calculate the average rating
    calculate_average_rating
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

  def calculate_average_rating
    if @google_reviews.present? && @google_reviews.any? { |review| review["rating"].present? }
      total_rating = @google_reviews.sum { |review| review["rating"].to_f }
      @average_rating = (total_rating / @google_reviews.size).round(2)
    else
      @average_rating = nil
    end
  end

  def fetch_yelp_reviews(yelp_business_id)
    yelp_api_key = ENV['YELP_API_KEY'] # Ensure you have this set in your env
    uri = URI("https://api.yelp.com/v3/businesses/#{yelp_business_id}/reviews")

    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{yelp_api_key}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      body = JSON.parse(response.body)
      body["reviews"] # Returns the reviews part of the response
    else
      Rails.logger.error "Failed to fetch Yelp reviews: #{response.message}"
      []
    end
  rescue => e
    Rails.logger.error "Error fetching Yelp reviews: #{e.message}"
    []
  end
end
