class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :user # Attendee
      t.references :lunch_date
      t.text :status

      t.timestamps
    end
  end
end
