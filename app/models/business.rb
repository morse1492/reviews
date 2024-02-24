class Business < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :emailtemplates, dependent: :destroy
  has_many :campaigns, dependent: :destroy
  has_many :users
  validates :google_place_id, uniqueness: true, allow_blank: true
  validates :yelp_business_id, uniqueness: true, allow_blank: true
end
