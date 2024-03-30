require 'rails_helper'

RSpec.feature "EventsFeature", type: :feature do
  before do
    Rails.application.load_seed

    @member1 = create(:member, :admin)

    # Setup mock OmniAuth user
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456789',
      info: {
        email: @member1.email,
        first_name: @member1.first_name,
        last_name: @member1.last_name,
        image: @member1.avatar_url
      },
      credentials: {
        token: "token",
        refresh_token: "refresh token",
        expires_at: DateTime.now,
      }
    })

    # Route to trigger the OmniAuth callback directly for testing
    visit member_google_oauth2_omniauth_callback_path
    
  end

    let(:new_event) {
        {
        name: "Events integration Test",
        location: "1234 Fake Street",
        start_time: "1:00PM",
        end_time: "2:00PM",
        date: Date.today,
        capacity: 40,
        points: 5,
        category: "Social Event",
        contact_info: "You can contact FakeUser@tamu.edu",
        description: "This is a description for test event"
        }
    }

  scenario "Create an event" do
    visit new_event_path

    fill_in "Name", with: "Events integration Test"
    fill_in "Location", with: "1234 Fake Street"
    fill_in "Start Time", with: "1:00PM"
    fill_in "End Time", with: "2:00PM"
    fill_in "Date", with: Date.today
    select 'Social Event', from: 'event[category]'
    fill_in "Capacity", with: "40"
    fill_in "Points", with: "5"
    # fill_in "Contact Information", with: "You can contact FakeUser@tamu.edu"
    fill_in "Description", with: "This is a test for the events integration test"

    click_button "Create Event"

    expect(page).to have_content("Event was successfully created")
    expect(page).to have_content("Events integration Test")
  end

  scenario "Create invalid event" do
    visit new_event_path

    fill_in "Name", with: "Events integration Test"
    fill_in "Location", with: "1234 Fake Street"
    fill_in "Start Time", with: "1:00PM"
    fill_in "End Time", with: "12:00PM"
    fill_in "Date", with: Date.today
    fill_in "Capacity", with: "40"
    fill_in "Points", with: "5"
    # fill_in "Contact Information", with: "You can contact FakeUser@tamu.edu"
    fill_in "Description", with: "This is a test for the events integration test"

    click_button "Create Event"

    expect(page).to have_content("End time must be after the start time")
  end

  scenario "View events list" do
    # Create some events to test against
    event1 = Event.create(name: "Event 1", location: "1234 Fake Street", start_time: "1:00PM", end_time: "2:00PM", date: Date.today, points: 5, category: "Social Event")
    event2 = Event.create(name: "Event 2", location: "1234 Fake Street", start_time: "1:00PM", end_time: "2:00PM", date: Date.today, points: 5, category: "Coffee Break")

    visit events_path

    expect(page).to have_content(event1.name)
    expect(page).to have_content(event2.name)
  end

  scenario "View event details" do
    event = Event.create(new_event)

    visit event_path(event)

    expect(page).to have_content(event.name)
    expect(page).to have_content(event.location)
    expect(page).to have_content(event.points)
  end


  scenario "Update event details" do
    event = Event.create(new_event)

    visit event_path(event)

    click_link "Edit Event Details"

    fill_in "Name", with: "New name"
    fill_in "Points", with: "10"
    # Update other fields as needed

    click_button "Update Event"

    expect(page).to have_content("Event was successfully updated")

    visit event_path(event)

    expect(page).to have_content("New name")
    expect(page).to have_content("10")
  end

  scenario "Update event details with invalid values" do
    event = Event.create(new_event)

    visit event_path(event)

    click_link "Edit Event Details"

    fill_in "End Time", with: "12:00PM"
    # Update other fields as needed

    click_button "Update Event"

    expect(page).to have_content("End time must be after the start time")
  end

  scenario "Delete an event" do

    event = Event.create(new_event)

    visit event_path(event)
    click_link "Delete Event"
    click_button "Delete"

    expect(page).to have_content("Event was successfully deleted.")
    # expect(page).not_to have_content(event.name)
  end
end
