# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
[
  {
    name: 'Admin',
    permissions: 'Create, Read, Update, Delete'
  },
  {
    name: 'Officer',
    permissions: 'Create, Read, Update'
  },
  {
    name: 'Member',
    permissions: 'Read'
  },
  {
    name:"Unapproved",
    permissions: "None"
  }
].each do |role|
  Role.find_or_create_by(role)
end

# Create a mock event
# event = Event.find_or_create_by(name: "Test Event") do |event|
#   event.location = "Test Location"
#   event.start_time = Time.zone.now
#   event.end_time = Time.zone.now + 1.hour
#   event.date = Time.zone.today
#   event.description = "This is a test event"
#   event.capacity = 100
#   event.points = 10
#   event.contact_info = "test@example.com"
#   event.category = "Test Category"
#   event.archive = false
# end

Event.find_or_create_by!(name: 'Test Event', location: 'Test Location', start_time: Time.zone.now + 1.hour, end_time: Time.zone.now + 2.hour, date: Time.zone.today + 1.day,
                         description: 'This is a test event', capacity: 100, points: 10, contact_info: 'test@example.com', category: 'Test Category', archive: false
)

# Create a mock notification
Notification.find_or_create_by(title: "Test Notification") do |notification|
  notification.description = "This is a test notification"
  notification.event_id = Event.first.id
  notification.date = Date.today
end