class LunchDate < ActiveRecord::Base
  belongs_to :creator, class_name: 'User'
  has_many :matches
  has_many :users, through: :matches
end
