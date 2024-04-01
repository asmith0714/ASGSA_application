# spec/policies/member_notification_policy_spec.rb
require 'rails_helper'

RSpec.describe MemberNotificationPolicy do
  before do 
    Rails.application.load_seed
  end

  subject { described_class }

  let(:admin) { create(:member, :admin) }
  let(:officer) { create(:member, :officer) }
  let(:member) { create(:member) }
  let(:unapproved) { create(:member, :unapproved) }

  permissions :index?, :show? do
    it 'grants access if user is approved' do
      expect(subject).to permit(admin)
      expect(subject).to permit(officer)
      expect(subject).to permit(member)
    end

    it 'denies access if user is not approved' do
      expect(subject).not_to permit(unapproved)
    end
  end

  permissions :new?, :create?, :destroy? do
    it 'grants access if user is an admin or officer' do
      expect(subject).to permit(admin)
      expect(subject).to permit(officer)
    end

    it 'denies access if user is not an admin or officer' do
      expect(subject).not_to permit(member)
      expect(subject).not_to permit(unapproved)
    end
  end

  permissions :edit?, :mark_seen?, :update? do
    it 'grants access if user is an admin, officer, or the record owner' do
      expect(subject).to permit(admin, admin)
      expect(subject).to permit(officer, officer)
      expect(subject).to permit(member, member)
    end

    it 'denies access if user is not an admin, officer, or the record owner' do
      expect(subject).not_to permit(member, admin)
      expect(subject).not_to permit(unapproved, admin)
    end
  end
end