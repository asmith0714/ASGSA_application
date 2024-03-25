# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('member_notifications/show', type: :view) do
  let(:valid_event) do
    Event.create!(
      name: 'Test Event',
      location: 'College Station',
      start_time: Time.zone.now,
      end_time: Time.current + 2.hours,
      date: Time.zone.today,
      description: 'This is a description for test event',
      capacity: 20,
      points: 3
    )
  end
  let(:valid_notification) do
    Notification.create!(
      title: 'Test notification',
      description: 'A test description',
      date: Time.zone.today,
      event_id: valid_event.id
    )
  end
  let(:valid_member) do
    Member.create!(
      first_name: 'John',
      last_name: 'Doe',
      email: 'john.doe@tamu.edu',
      points: 100,
      position: 'Member',
      date_joined: Time.zone.today,
      degree: 'Bachelor',
      res_topic: 'Topic',
      res_lab: 'Lab',
      res_pioneer: 'Pioneer',
      res_description: 'Description',
      area_of_study: 'Study Area',
      food_allergies: 'None'
    )
  end

  before do
    assign(:member_notification, MemberNotification.create!(
                                   member_id: valid_member.id,
                                   notification_id: valid_notification.id,
                                   seen: false
                                 )
    )
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to(match(/Test notification/))
    expect(rendered).to(match(/A test description/))
    expect(rendered).to(match(/Test Event/))
  end
end
