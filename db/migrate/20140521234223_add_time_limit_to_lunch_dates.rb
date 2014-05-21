class AddTimeLimitToLunchDates < ActiveRecord::Migration
  def change
    change_table :lunch_dates do |t|
      t.text :time_limit
    end
  end
end
