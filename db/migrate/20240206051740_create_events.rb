class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :name
      t.string :location
      t.time :start_time
      t.time :end_time
      t.date :date
      t.string :description
      t.integer :capacity, null: true # making capacity optional
      t.integer :points

      t.timestamps
    end
  end
end
