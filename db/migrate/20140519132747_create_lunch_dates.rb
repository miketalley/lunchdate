class CreateLunchDates < ActiveRecord::Migration
  def change
    create_table :lunch_dates do |t|
      t.references :creator, index: true
      t.references :attendee, index: true
      t.text :location_name
      t.float :latitude
      t.float :longitude
      t.datetime :date_time

      t.timestamps
    end
  end
end