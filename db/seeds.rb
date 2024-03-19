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
    name:"Admin",
    permissions: "Create, Read, Update, Delete"
  },
  {
    name:"Officer",
    permissions: "Create, Read, Update"
  },
  {
    name:"Member",
    permissions: "Read"
  }
].each do |role|
  Role.find_or_create_by(role)
end

# Create a mock event
Event.find_or_create_by(name: "Mock Event", location: "1234 Fake St", start_time: Time.now, end_time: Time.now + 1.hour, date: Date.today, description: "This is a mock event", capacity: 100, points: 1, contact_info: "123-456-7890")
Notification.find_or_create_by(title: "Mock Notification", description: "This is a mock notification", date: Date.today)


