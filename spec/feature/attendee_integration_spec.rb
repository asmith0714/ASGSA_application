# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Attendee Features', type: :feature) do
  before do
    # Manually create event / member here
    @event = Event.create!(
      name: 'name',
      location: 'location',
      start_time: Time.zone.now + 100_000,
      end_time: Time.zone.now + 100_000,
      date: Time.zone.today,
      description: 'Sample Description',
      capacity: 100,
      points: 5
    )

    @event_bad = Event.create!(
      name: 'name',
      location: 'location',
      start_time: Time.zone.now,
      end_time: Time.zone.now,
      date: Time.zone.today - 1,
      description: 'Sample Description',
      capacity: 100,
      points: 5
    )

    Rails.application.load_seed

    # Setup mock OmniAuth user
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456789',
      info: {
        email: 'john@tamu.edu',
        first_name: 'John',
        last_name: 'Doe',
        image: 'https://example.com/image.jpg'
      },
      credentials: {
        token: 'token',
        refresh_token: 'refresh token',
        expires_at: DateTime.now
      }
    }
                                                                      )

    visit member_google_oauth2_omniauth_callback_path

    @member = Member.find_by(email: 'john@tamu.edu')
  end

  it 'RSVP for an event' do
    visit new_event_attendee_path(@event)

    expect(page).to(have_content(@member.first_name))
    expect(page).to(have_content(@event.name))
    click_button 'Confirm RSVP'

    expect(page).to(have_content('RSVP was successfully created.'))
    expect(page).to(have_content(@member.first_name))
    expect(page).to(have_content(@event.name))

    visit new_event_attendee_path(@event)
    expect(page).to(have_content("You have already RSVP'd for this event."))
  end

  it 'Delete Attendee' do
    visit new_event_attendee_path(@event)
    click_button 'Confirm RSVP'
    visit event_attendees_path(@event)
    click_link 'Delete RSVP'
    click_button 'Delete RSVP'

    expect(page).to(have_content('RSVP was successfully destroyed.'))
    expect(page).not_to(have_content(@member.first_name))
  end

  it 'Test check_in filter' do
    visit new_event_attendee_path(@event)
    click_button 'Confirm RSVP'

    visit check_in_event_attendees_path(@event, member_filter: 'Non-RSVP')
    expect(page).not_to(have_content(@member.first_name))
  end

  it 'Check Member In / Out' do
    # Check in for non-rsvp
    visit check_in_event_attendees_path(@event, member_filter: 'Non-RSVP')
    find("a[href*=\"member_id=#{@member.member_id}\"]").click
    click_button 'Confirm Check In'

    expect(page).to(have_content('Member was successfully checked in.'))

    # Check that the member is Attended
    visit check_in_event_attendees_path(@event, member_filter: 'Attended')
    expect(page).to(have_content(@member.first_name))

    # Check Member Out
    click_link 'Uncheck Member'
    expect(page).not_to(have_content(@member.first_name))

    # Check that Member is in RSVP filter
    visit check_in_event_attendees_path(@event, member_filter: 'RSVP')

    # Check Member in that has RSVP'd
    click_link 'Check In'
    expect(page).to(have_content('Uncheck Member'))
  end

  it 'Show Attended' do
    visit check_in_event_attendees_path(@event)
    find("a[href*=\"member_id=#{@member.member_id}\"]").click
    click_button 'Confirm Check In'

    select 'Attended', from: 'member_filter'

    expect(page).to(have_content(@member.first_name))
  end

  it 'Create RSVP Rainy Day' do
    visit new_event_attendee_path(@event_bad)

    expect(page).to(have_content('The sign-up window for this event has closed.'))
  end

  it 'Delete RSVP after attended' do
    visit check_in_event_attendees_path(@event)
    find("a[href*=\"member_id=#{@member.member_id}\"]").click
    click_button 'Confirm Check In'

    visit event_attendees_path(@event)
    click_link 'Delete RSVP'
    click_button 'Delete RSVP'
  end
end
