class LunchDate < ActiveRecord::Base
  TIME_LIMIT = ['30 Minutes', '60 Minutes']

  belongs_to :creator, class_name: 'User'
  has_many :matches
  has_many :users, through: :matches

  def send_date_confirm_email(creator, acceptor, lunch_date)
    Pony.mail(to: creator.email, subject: "#{acceptor.username} has accepted your date!", body: "#{acceptor.username} has viewed and accepted your date proposal...\n #{lunch_date.location_name} \n #{lunch_date.date_time.strftime("%m/%d/%y - %I:%M%p")}")
  end

  def expired
    self.date_time < Date.today
  end

end
