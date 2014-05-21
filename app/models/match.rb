class Match < ActiveRecord::Base
  belongs_to :user
  belongs_to :lunch_date

end
