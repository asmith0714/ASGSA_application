# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do

    let(:valid_attributes) {
        {
        name: "Test Event",
        location: "College Station",
        date: Time.zone.today,
        start_time: "1:00PM",
        end_time: "2:00PM",
        capacity: 20,
        points: 3,
        contact_info: "Contact FakeEmail@tamu.edu for more information",
        description: "This is a description for test event", 
        category: "Social Event"
        }
    }
  end

  context 'validations' do
    it 'Is valid with valid attributes' do
      event = described_class.new(valid_attributes)
      expect(event).to(be_valid)
    end

    it 'Is not valid without name' do
      event = described_class.new(valid_attributes.merge(name: nil))
      expect(event).not_to(be_valid)
    end

    it 'Is not valid without location' do
      event = described_class.new(valid_attributes.merge(location: nil))
      expect(event).not_to(be_valid)
    end

    it 'Is not valid without date' do
      event = described_class.new(valid_attributes.merge(date: nil))
      expect(event).not_to(be_valid)
    end

    it 'End time before start time' do
      event = described_class.new(valid_attributes.merge(start_time: '1:00PM', end_time: '12:00PM'))
      expect(event).not_to(be_valid)
    end

    it 'Is not valid with negative capacity' do
      event = described_class.new(valid_attributes.merge(capacity: -1))
      expect(event).not_to(be_valid)
    end

    it 'Is not valid with negative points' do
      event = described_class.new(valid_attributes.merge(points: -1))
      expect(event).not_to(be_valid)
    end
  end
end
