require 'google_places'
require 'pry'

client = GooglePlaces::Client.new('AIzaSyBW5YthsYHaqiVpokxHvAbXF2UfEU10dHw')
locations = client.spots_by_query('51 Melcher St, Boston, Ma')# , types: 'food')
binding.pry
puts "Places are #{locations.inspect}"
