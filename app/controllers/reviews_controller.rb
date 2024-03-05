class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_business

  def index
    @business = current_user.business
    redirect_to root_path, alert: "No business associated with the current user." unless @business

    @google_reviews = fetch_google_reviews(ENV['GOOGLE_API_KEY'], @business.google_place_id) if @business.google_place_id.present?
    @yelp_reviews = fetch_yelp_reviews(ENV['YELP_API_KEY'], @business.yelp_business_id) if @business.yelp_business_id.present?
  end

  # Placeholder actions for responding to reviews
  def respond_to_google_review
    # Logic for responding to a Google review will go here
    flash[:notice] = "Response functionality for Google reviews is not implemented yet."
    redirect_to reviews_path
  end

  def respond_to_yelp_review
    # Logic for responding to a Yelp review will go here
    flash[:notice] = "Response functionality for Yelp reviews is not implemented yet."
    redirect_to reviews_path
  end

  def show_reviews
    # Fetch Google Business reviews using the Google Places API
    @google_reviews = fetch_google_reviews(ENV['GOOGLE_API_KEY'], @business.google_place_id) if @business.google_place_id

    # Fetch Yelp reviews
    @yelp_reviews = fetch_yelp_reviews(ENV['YELP_API_KEY'], @business.yelp_business_id) if @business.yelp_business_id
  end

  private

  def set_business
    @business = current_user.business
  end

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

  # Yelp Reviews

  def fetch_yelp_reviews(api_key, business_id)
    uri = URI("https://api.yelp.com/v3/businesses/#{business_id}/reviews")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{api_key}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      body = JSON.parse(response.body)
      return body["reviews"] if body && body["reviews"]
    else
      Rails.logger.error "Error fetching Yelp reviews: #{response.message}"
    end

    []
  end

end
