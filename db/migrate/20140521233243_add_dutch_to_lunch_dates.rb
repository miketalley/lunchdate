class AddDutchToLunchDates < ActiveRecord::Migration
  def change
    change_table :lunch_dates do |t|
      t.boolean :dutch
    end
  end
end
