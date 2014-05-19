class LunchDate < ActiveRecord::Base
  has_many :users_lunchdates
  has_many :users, through: :users_lunchdates
end
