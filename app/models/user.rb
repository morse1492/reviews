class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  belongs_to :business, optional: true
  accepts_nested_attributes_for :business
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
