class LunchDate < ActiveRecord::Base
  belongs_to :creator, class_name: 'User'
  has_many :matches
  has_many :users, through: :matches

  def send_date_confirm_email(creator, acceptor, lunch_date)
    Pony.mail(to: creator.email, subject: "#{acceptor.username} has accepted your date!", body: "#{acceptor.username} has viewed and accepted your date proposal...\n #{lunch_date.location_name} \n #{lunch_date.date_time.strftime("%m/%d/%y - %I:%M%p")}")
  end

  def expired
    self.date_time < Date.today
  end

  def infoWindow_details
    "<span class='iwstyle'>" + "#{lunch_date.location_name}" + "<br />" + "#{lunch_date.date_time.strftime("%m/%d/%y - %I:%M%p")}" + "<br />" + "#{lunch_date.creator.username}" + "</span>"
  end

  def gmaps_marker_hash(lunch_dates_to_mark)
    Gmaps4rails.build_markers(lunch_dates_to_mark) do |lunch_date, marker|
      marker.lat lunch_date.latitude
      marker.lng lunch_date.longitude
      marker.infowindow infoWindow_details
    end
  end

  def age(dob)
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

end
