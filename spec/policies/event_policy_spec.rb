# frozen_string_literal: true
require 'rails_helper'

RSpec.describe EventPolicy do
  before do
    Rails.application.load_seed
  end

RSpec.describe(EventPolicy, type: :policy) do
  subject { described_class }

  let(:admin) { create(:member, :admin) }
  let(:member) { create(:member) }
  let(:officer) { create(:member, :officer) }
  let(:unapproved) { create(:member, :unapproved) }
  let(:event) {
        {
        name: "Events integration Test",
        location: "1234 Fake Street",
        start_time: "1:00PM",
        end_time: "2:00PM",
        date: Date.today,
        capacity: 40,
        points: 5,
        category: "Social Event",
        contact_info: "You can contact FakeUser@tamu.edu",
        description: "This is a description for test event"
        }
    }

  permissions :index?, :show? do
    it 'grants access to admin, officer, and member' do
      expect(subject).to permit(admin, event)
      expect(subject).to permit(officer, event)
      expect(subject).to permit(member, event)
    end

    it 'denies access to other users' do
      expect(subject).not_to permit(unapproved, event)
    end
  end

  permissions :new?, :create?, :edit?, :update?, :destroy?, :delete_confirmation? do
    it 'grants access to admin and officer' do
      expect(subject).to permit(admin, event)
      expect(subject).to permit(officer, event)
    end

    it 'denies access to member and other users' do
      expect(subject).not_to permit(member, event)
      expect(subject).not_to permit(unapproved, event)
    end
  end
end
