# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Notification, type: :model) do
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
  # Define a valid member
  let(:valid_attributes) do
    {
      title: 'Test notification',
      description: 'A test description',
      date: Time.zone.today,
      event_id: valid_event.id
    }
  end

  context 'validations' do
    it 'is valid with valid attributes' do
      notification = described_class.new(valid_attributes)

      expect(notification).to(be_valid)
    end

    it 'is not valid without a title' do
      invalid_attributes = valid_attributes.merge(title: nil)
      notification = described_class.new(invalid_attributes)
      expect(notification).not_to(be_valid)
    end

    it 'is not valid without a date' do
      invalid_attributes = valid_attributes.merge(date: nil)
      notification = described_class.new(invalid_attributes)
      expect(notification).not_to(be_valid)
    end

    it 'is not valid without a description' do
      notification = described_class.new(valid_attributes.merge(description: nil))
      expect(notification).not_to(be_valid)
    end
  end
end
