class Emailtemplate < ApplicationRecord
  belongs_to :business
  has_many :campaign
end
