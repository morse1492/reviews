class AnalyticsController < ApplicationController
  before_action :authenticate_user!

  def index
    @business = current_user.business
    @reviews = @business.reviews
    @campaigns = @business.campaigns
    # @email_templates = @business.email_templates

    google_api_key = ENV['GOOGLE_API_KEY']
    @google_reviews = fetch_google_reviews(google_api_key, @business.google_place_id) if @business.google_place_id

    calculate_average_rating

    yelp_api_key = ENV['YELP_API_KEY']
    @yelp_reviews = fetch_yelp_reviews(yelp_api_key, @business.yelp_business_id) if @business.yelp_business_id


    # Prepare data for Chartkick
    @google_reviews_by_month = calculate_google_reviews_by_month(@google_reviews)
    @yelp_reviews_by_month = calculate_yelp_reviews_by_month(@yelp_reviews)

    # for bar chart
    @google_reviews_count = @google_reviews.size
    @yelp_reviews_count = @yelp_reviews.size

    # Calculate review counts
    @total_reviews_count = calculate_total_reviews_count
    @negative_reviews_count = calculate_negative_reviews_count
    @positive_reviews_count = calculate_positive_reviews_count

    calculate_yelp_average_rating

    # Prepare data for Chartkick
    @yelp_reviews_by_month = calculate_reviews_by_month(@yelp_reviews)

    # Prepare data for pie chart
    @yelp_reviews_by_rating = @yelp_reviews.each_with_object(Hash.new(0)) do |review, counts|
      counts["#{review["rating"]} stars"] += 1
    end

  end

  private

    # Google Reviews

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

  def calculate_yelp_reviews_by_month(reviews)

    reviews_by_month = reviews.group_by { |review| review["time_created"].to_date.beginning_of_month }
    reviews_count_by_month = reviews_by_month.transform_values(&:count)

    sorted_reviews_count = reviews_count_by_month.sort.to_h

    cumulative_reviews_count = 0
    cumulative_reviews_data = sorted_reviews_count.transform_values do |reviews_count|
      cumulative_reviews_count += reviews_count
    end
  end


  def calculate_google_reviews_by_month(reviews)
    return {} if reviews.nil? || reviews.empty?

    reviews_by_month = reviews.group_by { |review| Time.at(review["time"]).to_date.beginning_of_month }
    reviews_count_by_month = reviews_by_month.transform_values(&:count)
    sorted_reviews_count = reviews_count_by_month.sort.to_h
  end

  def calculate_total_reviews_count
    (@google_reviews.try(:size) || 0) + (@yelp_reviews.try(:size) || 0)
  end

  def calculate_negative_reviews_count
    (@google_reviews.try(:count) { |review| review["rating"] < 3 } || 0) +
      (@yelp_reviews.try(:count) { |review| review["rating"] < 3 } || 0)
  end

  def calculate_positive_reviews_count
    (@google_reviews.try(:count) { |review| review["rating"] > 3 } || 0) +
      (@yelp_reviews.try(:count) { |review| review["rating"] > 3 } || 0)
  end

  def calculate_average_rating
    if @google_reviews.present? && @google_reviews.any? { |review| review["rating"].present? }
      total_rating = @google_reviews.sum { |review| review["rating"].to_f }
      @average_rating = (total_rating / @google_reviews.size).round(2)
    else
      @average_rating = nil
    end
  end

  def calculate_yelp_average_rating
    if @yelp_reviews.present? && @yelp_reviews.any? { |review| review["rating"].present? }
      total_yelp_rating = @yelp_reviews.sum { |review| review["rating"].to_f }
      @yelp_average_rating = (total_yelp_rating / @yelp_reviews.size).round(2)
    else
      @yelp_average_rating = nil
    end
  end

  def calculate_reviews_by_month(reviews)

    reviews_by_month = reviews.group_by { |review| review["time_created"].to_date.beginning_of_month }
    reviews_count_by_month = reviews_by_month.transform_values(&:count)

    sorted_reviews_count = reviews_count_by_month.sort.to_h

    cumulative_reviews_count = 0
    cumulative_reviews_data = sorted_reviews_count.transform_values do |reviews_count|
      cumulative_reviews_count += reviews_count
    end
  end

end
