class LunchDatesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_lunch_date, only: [:show, :edit, :update, :destroy]
  CURRENT_USER = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])


  def index
    @unconfirmed_other_users_lunch_dates = []
    @lunch_dates = LunchDate.all
    @lunch_dates.each do |ld|
      if (
        (ld.creator != current_user) &&
        (!ld.matches.map{ |match| match.status }.include? 'Confirmed') &&
        (!ld.expired)
        )
        @unconfirmed_other_users_lunch_dates << ld
      end
    end
    @unconfirmed_other_users_lunch_dates.sort_by{:date_time}
    @hash = Gmaps4rails.build_markers(@unconfirmed_other_users_lunch_dates) do |lunch_date, marker|
      marker.lat lunch_date.latitude
      marker.lng lunch_date.longitude
      marker.infowindow "<span class='iwstyle'>" + "#{lunch_date.location_name}" + "<br />" + "#{lunch_date.date_time.strftime("%m/%d/%y - %I:%M%p")}" + "<br />" + "#{lunch_date.creator.username}" + "</span>"
      # infoWindow_details
    end
    # Broken but keep for later -- in model
    # gmaps_marker_hash(@unconfirmed_other_users_lunch_dates)
  end

  def show
    @single_date_hash = Gmaps4rails.build_markers(@lunch_date) do |lunch_date, marker|
      marker.lat lunch_date.latitude
      marker.lng lunch_date.longitude
      marker.infowindow "<span class='iwstyle'>" + "#{lunch_date.location_name}" + "<br />" + "#{lunch_date.date_time.strftime("%m/%d/%y - %I:%M%p")}" + "<br />" + "#{lunch_date.creator.username}" + "</span>"
      #infoWindow_details
    end
    # Broken but keep for later -- in model
    # gmaps_marker_hash(@lunch_date)
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
    redirect_to root_path, message: 'Date Deleted'
  end

  def new_query
  end

  def query_result
    coordinates = []
    client = CURRENT_USER
    coordinates = Geocoder.coordinates(params[:query_term])
    @locations = client.spots(coordinates[0], coordinates[1], types: ['restaurant', 'food'], radius: 1000)
  end

  def accept_date
    lunch_date = LunchDate.find(params[:id])
    @match = Match.new
    @match.user = current_user
    @match.lunch_date = lunch_date
    @match.status = 'Pending Confirmation'
    # This should have Pony send a confirmation request to the creator
    # send_date_confirm_email(lunch_date.creator, current_user, lunch_date)
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
    @lunch_dates = all_dates.select {|date| date.creator == current_user}
  end

  def my_matches
    all_matches = Match.all
    @matches = []
    @matches = all_matches.select {|match| match.user == current_user}
  end

  def confirm_date
    lunch_date_to_confirm = LunchDate.find(params[:id])
    match_to_confirm = Match.find(params[:match_id_to_confirm])
    match_to_confirm.status = 'Confirmed'
    lunch_date_to_confirm.matches.each do |match|
      if match != match_to_confirm
        match.status = 'Cancelled - User Accepted Another Date'
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
      :updated_at
    )
  end

  private

  def set_lunch_date
    @lunch_date = LunchDate.find(params[:id])
  end

end
