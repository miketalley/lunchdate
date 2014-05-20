class AddAttributesToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.text :username, null: false
      t.datetime :dob, null: false
      t.string :gender, null: false
      t.string :sexual_orientation, null: false
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :image_url
      t.string :quote

      t.index :username, unique: true
    end
  end
end
