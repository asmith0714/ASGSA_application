require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:valid_event) { Event.create!(
    name: "Test Event",
    location: "College Station",
    start_time: Time.now ,
    end_time: Time.current + 2.hour,
    date: Date.today,
    description: "This is a description for test event",
    capacity: 20,
    points: 3, 
    category: "Social Event"
  ) }
  #Define a valid member
  let(:valid_attributes){
    {
      title: "Test notification",
      description: "A test description",
      date: Date.today,
      event_id: valid_event.id
    }
  }

  context 'validations' do
    it 'is valid with valid attributes' do
      notification = Notification.new(valid_attributes)

      expect(notification).to be_valid
    end

    it 'is not valid without a title' do
      invalid_attributes = valid_attributes.merge(title: nil)
      notification = Notification.new(invalid_attributes)
      expect(notification).not_to be_valid
    end

    it 'is not valid without a date' do
      invalid_attributes = valid_attributes.merge(date: nil)
      notification = Notification.new(invalid_attributes)
      expect(notification).not_to be_valid
    end

    it 'is not valid without a description' do
      notification = Notification.new(valid_attributes.merge(description: nil))
      expect(notification).not_to be_valid
    end
  end
end
