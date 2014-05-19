class LunchDatesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]

  def index
    @lunch_dates = LunchDate.all
    @hash = Gmaps4rails.build_markers(@lunch_dates) do |lunch_date, marker|
      marker.lat lunch_date.latitude
      marker.lng lunch_date.longitude
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
      :date_time
    )
    #   'date_time(1i)', # Year
    #   'date_time(2i)', # Month
    #   'date_time(3i)', # Day
    #   'date_time(4i)', # Hour in Military
    #   'date_time(5i)'  # Minute
    # )
  end

end
