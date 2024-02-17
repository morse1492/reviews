class Business < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :emailtemplates, dependent: :destroy
  has_many :campaigns, dependent: :destroy
  has_many :users
end
