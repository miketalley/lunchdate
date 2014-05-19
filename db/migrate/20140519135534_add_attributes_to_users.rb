class AddAttributesToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.text :username, null: false
      t.datetime :dob, null: false
      t.string :city
      t.string :state
      t.string :zipcode
      t.index :username, unique: true
    end
  end
end
