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
      points: 3,
      category: 'Social Event'
    )
  end
  let(:notification) do
    described_class.new(title: 'Test Notification', description: 'A test description', date: Time.zone.today, event: valid_event)
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

  # Directly inside your RSpec.describe block, define a method to attach files
  def attach_file_to(notification, filename, content_type)
    # Create a mock file using StringIO, including the original filename
    mock_file = Rack::Test::UploadedFile.new(
      StringIO.new('Fake file content'),
      content_type,
      original_filename: filename # Provide the original filename here
    )

    # Attach the mock file to the notification object
    notification.attachment.attach(mock_file)
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

  context 'attachment validations' do
    it 'is valid with a JPEG file attached' do
      attach_file_to(notification, 'test.jpeg', 'image/jpeg')
      expect(notification).to(be_valid)
    end

    it 'is valid with a PNG file attached' do
      attach_file_to(notification, 'test.png', 'image/png')
      expect(notification).to(be_valid)
    end

    it 'is valid with a PDF file attached' do
      attach_file_to(notification, 'test.pdf', 'application/pdf')
      expect(notification).to(be_valid)
    end

    it 'is not valid with a GIF file attached' do
      attach_file_to(notification, 'test.gif', 'image/gif')
      notification.valid?
      expect(notification.errors[:attachment]).to(include('must be a JPEG, JPG, PNG, or PDF file'))
    end
  end
end
