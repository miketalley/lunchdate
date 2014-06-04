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

  def self.getScrubbedDates(current_user)
    scrubbedDates = []
    alldates = LunchDate.all.sort_by{ |date| date.date_time}.reverse
    alldates.each do |ld|
      if (
        (ld.creator != current_user) &&
        (!ld.matches.map{ |match| match.status }.include? 'Confirmed') &&
        (!ld.expired)
        )
        scrubbedDates << ld
      end
    end
    return scrubbedDates
  end

#Working on using this and moving out of controller
  def accept_date
    lunch_date = LunchDate.find(params[:id])
    @match = Match.new
    @match.user = current_user
    @match.lunch_date = lunch_date
    @match.status = 'Pending Confirmation'
    # This should have Pony send a confirmation request to the creator
    # send_date_confirm_email(lunch_date.creator, current_user, lunch_date)
    TwilioClient.account.messages.create( :from => '+16176069565', :to => current_user.phone, :body => 'Date Pending Confirmation', :media_url => 'http://www.clker.com/cliparts/5/X/a/g/I/6/confirm-button.svg', )

    if @match.save
      flash[:message] = "Email Sent to Creator\nLunch Date is Pending Confirmation"
      redirect_to lunch_date_path(lunch_date)
    else
      flash[:message] = 'Something went wrong'
      redirect_to lunch_date_path(lunch_date)
    end
  end

  def my_dates
    all_dates = LunchDate.all
    @lunch_dates = []
    @lunch_dates = all_dates.select {|date| date.creator == current_user}.sort_by{ |date| date.date_time}
  end

  def my_matches
    all_matches = Match.all
    @matches = []
    @matches = all_matches.select {|match| match.user == current_user}
    @confirmed_matches = []
    @unconfirmed_matches = []
    @matches.each do |match|
      if match.status == 'Confirmed'
        @confirmed_matches << match
      else
        @unconfirmed_matches << match
      end
    end
  end

  def confirm_date
    lunch_date_to_confirm = LunchDate.find(params[:id])
    match_to_confirm = Match.find(params[:match_id_to_confirm])
    match_to_confirm.status = 'Confirmed'
    lunch_date_to_confirm.matches.each do |match|
      if match != match_to_confirm
        match.status = 'Cancelled - User Accepted Another Date'
        match.save
      end
    end
    # This should have Pony send a confirmation email to creator and attendee
    # send_date_confirm_email(lunch_date.creator, current_user, lunch_date)
    # send_date_confirm_email(lunch_date.creator, current_user, lunch_date)
    if match_to_confirm.save
      flash[:message] = "Lunch Date Confirmed"
      redirect_to lunch_date_path(lunch_date_to_confirm)
    else
      flash[:message] = 'Something went wrong'
      redirect_to lunch_date_path(lunch_date_to_confirm)
    end
  end

end
