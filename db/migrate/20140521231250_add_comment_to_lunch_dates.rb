class AddCommentToLunchDates < ActiveRecord::Migration
  def change
    change_table :lunch_dates do |t|
      t.text :comment
    end
  end
end
