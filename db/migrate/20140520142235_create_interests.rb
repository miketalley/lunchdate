class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.text :name
      t.references :user

      t.index :name, unique: true

      t.timestamps
    end
  end
end
