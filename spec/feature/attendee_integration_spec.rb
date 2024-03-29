require 'rails_helper'

RSpec.feature "Attendee Features", type: :feature do
  before do
    # Manually create event / member here
    @event = Event.create!(
      name: "name",
      location: "location",
      start_time: Time.now + 100000,
      end_time: Time.now + 100000,
      date: Date.today,
      description: "Sample Description",
      capacity: 100,
      points: 5,
      category: "Test Category",
      archive:  false
    )

    @event_bad = Event.create!(
      name: "name",
      location: "location",
      start_time: Time.now,
      end_time: Time.now,
      date: Date.today - 1,
      description: "Sample Description",
      capacity: 100,
      points: 5, 
      category: "Test Category",
      archive: false
    )

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


    @member = @member1
  end

  scenario "RSVP for an event" do
    visit new_event_attendee_path(@event)

    expect(page).to have_content(@member.first_name)
    expect(page).to have_content(@event.name)
    click_button "Confirm RSVP"

    expect(page).to have_content("RSVP was successfully created.")
    expect(page).to have_content(@member.first_name)
    expect(page).to have_content(@event.name)

    visit new_event_attendee_path(@event)
    expect(page).to have_content("You have already RSVP'd for this event.")
  end

  scenario "Delete Attendee" do
    visit new_event_attendee_path(@event)
    click_button "Confirm RSVP"
    visit event_attendees_path(@event)
    click_link "Delete RSVP"
    click_button "Delete RSVP"

    expect(page).to have_content("RSVP was successfully destroyed.")
    expect(page).to_not have_content(@member.first_name)
  end

  scenario "Test check_in filter" do
    visit new_event_attendee_path(@event)
    click_button "Confirm RSVP"

    visit check_in_event_attendees_path(@event, member_filter: "Non-RSVP")
    expect(page).to_not have_content(@member.first_name)
  end

  scenario "Check Member In / Out" do
    #Check in for non-rsvp
    visit check_in_event_attendees_path(@event, member_filter: "Non-RSVP")
    find('a[href*="member_id=' + @member.member_id.to_s + '"]').click
    click_button "Confirm Check In"

    expect(page).to have_content("Member was successfully checked in.")

    #Check that the member is Attended
    visit check_in_event_attendees_path(@event, member_filter: "Attended")
    expect(page).to have_content(@member.first_name)

    #Check Member Out
    click_link "Uncheck Member"
    expect(page).to_not have_content(@member.first_name)

    #Check that Member is in RSVP filter
    visit check_in_event_attendees_path(@event, member_filter: "RSVP")

    #Check Member in that has RSVP'd
    click_link "Check In"
    expect(page).to_not have_content(@member.first_name)
  end

  scenario "Show Attended" do
    visit event_attendees_path(@event)
    click_link "RSVP For This Event"
    click_button "Confirm RSVP"

    visit check_in_event_attendees_path(@event, member_filter: "RSVP")
    click_link "Check In"

    visit check_in_event_attendees_path(@event, member_filter: "Attended")
    expect(page).to have_content(@member.first_name)
  end

  scenario "Create RSVP Rainy Day" do
    visit new_event_attendee_path(@event_bad)

    expect(page).to have_content("The sign-up window for this event has closed.")
  end

  scenario "Delete RSVP after attended" do
    visit event_attendees_path(@event)
    click_link "RSVP For This Event"
    click_button "Confirm RSVP"

    visit check_in_event_attendees_path(@event, member_filter: "RSVP")
    click_link "Check In"

    expect(page).to_not have_content(@member.first_name)
  end

end