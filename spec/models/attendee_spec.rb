require 'rails_helper'

RSpec.describe Attendee, type: :model do

  let(:valid_attributes) {
    {
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@tamu.edu",
      points: 100,
      position: "Member",
      date_joined: Date.today,
      degree: "Bachelor",
      res_topic: "Topic",
      res_lab: "Lab",
      res_pioneer: "Pioneer",
      res_description: "Description",
      area_of_study: "Study Area",
      food_allergies: "None"
    }
  }

  #create subject
  subject do
    event = Event.create(
      name: "name",
      location: "location",
      start_time: Time.now,
      end_time: Time.now,
      date: Date.today,
      description: "Sample Description",
      capacity: 100,
      points: 5
    )

    member = Member.create(valid_attributes)

    described_class.create(member_id: member.member_id, event_id: event.event_id, attended: true, rsvp: true )
  end

  #valid attributes
  it 'is valid with valid attribues' do
    expect(subject).to be_valid
  end

  it 'is not valid without an event_id' do
    subject.event_id = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a member_id' do
    subject.member_id = nil
    expect(subject).not_to be_valid
  end

  it 'is has unique member_id and event_id' do
    attendee = Attendee.create(event_id: subject.event_id, member_id: subject.member_id)
    expect(attendee).not_to be_valid
    expect(attendee.errors[:base]).to include("RSVP for this event has already been created")
  end
end
