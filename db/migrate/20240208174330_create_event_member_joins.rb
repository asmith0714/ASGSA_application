class CreateEventMemberJoins < ActiveRecord::Migration[7.1]
  def change
    create_table :event_member_joins do |t|
      t.boolean :attended
      t.boolean :rsvp

      t.timestamps
    end
  end
end
