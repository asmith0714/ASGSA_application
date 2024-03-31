
require 'rails_helper'

RSpec.describe NotificationPolicy, type: :policy do
  before do
    Rails.application.load_seed
  end
  event = Event.find_or_create_by(name: "Test Event") do |event|
    event.location = "Test Location"
    event.start_time = Time.now
    event.end_time = Time.now + 1.hour
    event.date = Time.zone.today
    event.description = "This is a test event"
    event.capacity = 100
    event.points = 10
    event.contact_info = "test@example.com"
    event.category = "Test Category"
    event.archive = false
  end

  subject { described_class }

  let(:admin) { create(:member, :admin) }
  let(:officer) { create(:member, :officer) }
  let(:member) { create(:member) }
  let(:unapproved) { create(:member, :unapproved) } 

  let(:notification) {
    {
    title: "Test Notification",
    description: "This is a test notification",
    event_id: event.id,
    date: Date.today
    }
  } 

  # describe 'Scope' do
  #   context 'for an admin' do
  #     it 'includes all notifications' do
  #       expect(Pundit.policy_scope!(admin, notification).resolve).to include(notification)
  #     end
  #   end

  #   context 'for an officer' do
  #     it 'includes all notifications' do
  #       expect(Pundit.policy_scope!(officer, notification).resolve).to include(notification)
  #     end
  #   end

  #   context 'for a member' do
  #     it 'does not include notifications not belonging to them' do
  #       expect(Pundit.policy_scope!(member, notification).resolve).not_to include(notification)
  #     end
  #   end
  # end

  permissions :index?, :show?, :new?, :create?, :edit?, :update?, :destroy?, :delete_confirmation? do
    it 'grants access to admin and officer' do
      expect(subject).to permit(admin, notification)
      expect(subject).to permit(officer, notification)
    end

    it 'denies access to regular members' do
      expect(subject).not_to permit(member, notification)
    end
  end
end