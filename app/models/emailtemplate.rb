class Emailtemplate < ApplicationRecord
  belongs_to :business
  has_many :campaign, dependent: :destroy
end
