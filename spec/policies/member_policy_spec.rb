# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(MemberPolicy, type: :policy) do
  before do
    Rails.application.load_seed
  end

  let(:admin) { create(:member, :admin) }
  let(:member) { create(:member) }
  let(:officer) { create(:member, :officer) }
  let(:other_member) { create(:member) }

  describe 'Scope' do
    subject { Pundit.policy_scope!(user, Member) }

    context 'for an admin' do
      let(:user) { admin }

      it 'includes all members' do
        member # Ensure the member is created
        expect(subject).to(include(member))
      end
    end
  end

  describe '#show?' do
    # Admins can see any profile
    it 'allows an admin to see any profile' do
      expect(described_class.new(admin, other_member)).to(be_show)
    end

    # Officers can see any profile
    it 'allows an officer to see any profile' do
      expect(described_class.new(officer, other_member)).to(be_show)
    end

    # Members can see their own profile
    it 'allows a member to see their own profile' do
      expect(described_class.new(member, member)).to(be_show)
    end

    # Members cannot see other members' profiles if they are not an admin or an officer
    it 'denies a member from seeing another member\'s profile' do
      expect(described_class.new(member, other_member)).to(be_show)
    end
  end

  # describe '#new?' do
  #   it 'allows admin and officer to access new member form' do
  #     expect(MemberPolicy.new(admin, nil).new?).to be_truthy
  #     expect(MemberPolicy.new(officer, nil).new?).to be_truthy
  #   end

  #   it 'denies regular members to access new member form' do
  #     expect(MemberPolicy.new(member, nil).new?).to be_falsey
  #   end
  # end
  describe '#edit?' do
    it 'allows admin, officer to update' do
      expect(described_class.new(admin, member)).to(be_update)
      expect(described_class.new(officer, member)).to(be_update)
      expect(described_class.new(member, member)).to(be_update)
    end

    it 'denies other members from updating' do
      expect(described_class.new(other_member, member)).not_to(be_update)
    end
  end

  describe '#update?' do
    it 'allows admin, officer to update' do
      expect(described_class.new(admin, member)).to(be_update)
      expect(described_class.new(officer, member)).to(be_update)
      expect(described_class.new(member, member)).to(be_update)
    end

    it 'denies other members from updating' do
      expect(described_class.new(other_member, member)).not_to(be_update)
    end
  end

  describe '#destroy?' do
    it 'allows admin and officer to delete a member' do
      expect(described_class.new(admin, member)).to(be_destroy)
      expect(described_class.new(officer, member)).to(be_destroy)
    end

    it 'denies regular members from deleting a member' do
      expect(described_class.new(member, member)).not_to(be_delete_confirmation)
      expect(described_class.new(member, other_member)).not_to(be_destroy)
    end
  end

  describe '#delete_confirmation?' do
    it 'denies admin and officer from accessing delete confirmation' do
      expect(described_class.new(admin, member)).not_to(be_delete_confirmation)
      expect(described_class.new(officer, member)).not_to(be_delete_confirmation)
    end

    it 'denies regular members from accessing delete confirmation' do
      expect(described_class.new(member, member)).not_to(be_delete_confirmation)
      expect(described_class.new(member, other_member)).not_to(be_delete_confirmation)
    end
  end
end
