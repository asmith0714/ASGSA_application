# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Event, type: :model) do
  let(:valid_attributes) do
    {
      name: 'Test Event',
      location: 'College Station',
      date: Time.zone.today,
      start_time: '1:00PM',
      end_time: '2:00PM',
      capacity: 20,
      points: 3,
      contact_info: 'Contact FakeEmail@tamu.edu for more information',
      description: 'This is a description for test event',
      category: 'Social Event'
    }
  end

  let(:event) do
    described_class.new(valid_attributes)
  end

  # Helper method to attach files to an event
  def attach_file_to(event, filename, content_type)
    mock_file = Rack::Test::UploadedFile.new(
      StringIO.new('Fake file content'),
      content_type,
      original_filename: filename
    )
    event.attachment.attach(mock_file)
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

  context 'validations' do
    # Existing validation tests
    it 'Is valid with valid attributes' do
      expect(event).to(be_valid)
    end
    # Add more validation tests as needed
  end

  context 'attachment validations' do
    it 'is valid with a JPEG file attached' do
      attach_file_to(event, 'test.jpeg', 'image/jpeg')
      expect(event).to(be_valid)
    end

    it 'is valid with a PNG file attached' do
      attach_file_to(event, 'test.png', 'image/png')
      expect(event).to(be_valid)
    end

    it 'is valid with a PDF file attached' do
      attach_file_to(event, 'test.pdf', 'application/pdf')
      expect(event).to(be_valid)
    end

    it 'is not valid with a GIF file attached' do
      attach_file_to(event, 'test.gif', 'image/gif')
      event.valid?
      expect(event.errors[:attachment]).to(include('must be a JPEG, JPG, PNG, or PDF file'))
    end
  end
end
