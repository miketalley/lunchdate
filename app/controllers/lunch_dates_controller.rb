class LunchDatesController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_lunch_date, only: [:show, :edit, :update, :destroy]
  GoogleClient = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
  TwilioClient = Twilio::REST::Client.new ENV['account_sid'], ENV['auth_token']


  def index
    @scrubbedDates = LunchDate.getScrubbedDates(current_user)
    @hash = Gmaps4rails.build_markers(@scrubbedDates) do |lunch_date, marker|
      marker.lat lunch_date.latitude
      marker.lng lunch_date.longitude
      marker.infowindow "<span class='iwstyle'>" + "#{lunch_date.location_name}" + "<br />" + "#{lunch_date.date_time.strftime("%m/%d/%y - %I:%M%p")}" + "<br />" + "#{lunch_date.creator.username}" + "</span>"
      #infoWindow_details
    end

    #gmaps_marker_hash(@unconfirmed_other_users_lunch_dates)
  end

  def show
    @zoom_level = 15
    @single_date_hash = Gmaps4rails.build_markers(@lunch_date) do |lunch_date, marker|
      marker.lat lunch_date.latitude
      marker.lng lunch_date.longitude
      marker.infowindow "<span class='iwstyle'>" + "#{lunch_date.location_name}" + "<br />" + "#{lunch_date.date_time.strftime("%m/%d/%y - %I:%M%p")}" + "<br />" + "#{lunch_date.creator.username}" + "</span>"
      #infoWindow_details
    end

    #gmaps_marker_hash(@lunch_date)
  end

  def new
    @lunch_date = LunchDate.new(
      location_name: params[:location_name],
      latitude: params[:latitude],
      longitude: params[:longitude]
    )
  end

  def create
    @lunch_date = LunchDate.new(lunch_date_params)
    @lunch_date.creator = current_user
    if @lunch_date.save
      redirect_to lunch_date_path(@lunch_date)
    else
      flash[:message] = 'Date Not Saved'
      render :new
    end
  end

  def edit
  end

  def update
    @lunch_date.update(lunch_date_params)
    redirect_to lunch_date_path(@lunch_date)
  end

  def destroy
    @lunch_date.destroy
    flash[:message] = 'Date Deleted'
    redirect_to my_dates_path
  end

  def new_query
  end

  def query_result
    coordinates = []
    client = GoogleClient
    coordinates = Geocoder.coordinates(params[:query_term])
    if coordinates.nil?
      flash[:message] = 'No Results Found'
      render :new_query
    else
      @locations = client.spots(coordinates[0], coordinates[1], types: ['restaurant', 'food'], radius: 1000)
    end
  end

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

  def lunch_date_params
    params.require(:lunch_date).permit(
      :location_name,
      :latitude,
      :longitude,
      :date_time,
      :created_at,
      :updated_at,
      :comment
    )
  end

  private

  def set_lunch_date
    @lunch_date = LunchDate.find(params[:id])
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

end
