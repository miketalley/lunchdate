class LunchDatesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_lunch_date, only: [:show, :edit, :update, :destroy]


  def index
    @lunch_dates = LunchDate.all
    @hash = Gmaps4rails.build_markers(@lunch_dates) do |lunch_date, marker|
      marker.lat lunch_date.latitude
      marker.lng lunch_date.longitude
      marker.infowindow lunch_date.location_name
    end
  end

  def show
    @single_date_hash  = Gmaps4rails.build_markers(@lunch_date) do |lunch_date, marker|
      marker.lat @lunch_date.latitude
      marker.lng @lunch_date.longitude
      marker.infowindow @lunch_date.location_name
    end
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
    client = GooglePlaces::Client.new('AIzaSyAwEEpQtRk32Ig2-NMbS2VfS4zdu5h7EZ4')
    coordinates = Geocoder.coordinates(params[:query_term])
    @locations = client.spots(coordinates[0], coordinates[1], types: ['restaurant', 'food'], radius: 1000)
  end

  def accept_date
    lunch_date = LunchDate.find(params[:id])
    @match = Match.new
    @match.user = current_user
    @match.lunch_date = lunch_date
    @match.status = 'Pending Confirmation'
    # This should have Pony send a confirmation email to the creator
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
    @lunch_dates = LunchDate.all
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
