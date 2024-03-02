class Campaign < ApplicationRecord
  belongs_to :business
  belongs_to :emailtemplate
end
