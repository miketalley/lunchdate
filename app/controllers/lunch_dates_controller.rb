class LunchDatesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  #before_action :set_lunch_date, only: [:show, :edit, :update, :destroy]


  def index
    @lunch_dates = LunchDate.all
    @hash = Gmaps4rails.build_markers(@lunch_dates) do |lunch_date, marker|
      marker.lat lunch_date.latitude
      marker.lng lunch_date.longitude
      marker.infowindow lunch_date.location_name
    end
  end

  def show
    @lunch_date = LunchDate.find(params[:id])
  end

  def new
    @lunch_date = LunchDate.new
  end

  def create
    @lunch_date = LunchDate.create(lunch_date_params)
    redirect_to lunch_date_path(@lunch_date)
  end

  def edit
    @lunch_date = LunchDate.find(params[:id])
  end

  def update
    lunch_date = LunchDate.find(params[:id])
    lunch_date.update(lunch_date_params)
    redirect_to lunch_date_path(lunch_date)
  end

  def destroy
    lunch_date = LunchDate.find(params[:id])
    lunch_date.destroy
    redirect_to root_path, message: 'Date Deleted'
  end

  def new_query
  end

  def query_result
    coordinates = []
    client = GooglePlaces::Client.new('AIzaSyBW5YthsYHaqiVpokxHvAbXF2UfEU10dHw')
    coordinates = Geocoder.coordinates(params[:query_term])
    @locations = client.spots(coordinates[0], coordinates[1], types: ['restaurant', 'food'], radius: 1000)
  end

  def lunch_date_params
    params.require(:lunch_date).permit(
      :creator_id,
      :attendee_id,
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
    if user_signed_in?
      @lunch_date = current_user.lunch_dates.find(lunch_date_params)
    else
      @lunch_date = LunchDate.find(lunch_date_params)
    end
  end

end
