require 'rails_helper'

RSpec.describe MemberRolePolicy, type: :policy do
  before do
    Rails.application.load_seed
  end

  subject { described_class }

  let(:admin) { create(:member, :admin) }
  let(:officer) { create(:member, :officer) }
  let(:member) { create(:member) }
  let(:unapproved) { create(:member, :unapproved) }

  # Assuming MemberRole actions don't require an instance of a specific record,
  # you can use a generic object or nil where a record is needed for policy checks.
  let(:member_role) { nil }

  describe 'Permissions' do
    describe '#index?' do
      it 'allows admin to access member roles page' do
        expect(MemberRolePolicy.new(admin, member_role).index?).to be_truthy
      end

      it 'denies access to officer and member' do
        expect(MemberRolePolicy.new(officer, member_role).index?).to be_falsey
        expect(MemberRolePolicy.new(member, member_role).index?).to be_falsey
        expect(MemberRolePolicy.new(unapproved, member_role).index?).to be_falsey

      end
    end

    describe '#show?' do
      it 'allows admin to view a member role detail' do
        expect(MemberRolePolicy.new(admin, member_role).show?).to be_truthy
      end

      it 'denies access to officer and member' do
        expect(MemberRolePolicy.new(officer, member_role).show?).to be_falsey
        expect(MemberRolePolicy.new(member, member_role).show?).to be_falsey
        expect(MemberRolePolicy.new(unapproved, member_role).show?).to be_falsey
      end
    end

    # Repeat the structure for other actions: new?, create?, edit?, update?, destroy?

    describe '#create?' do
      it 'allows admin to create a member role' do
        expect(MemberRolePolicy.new(admin, member_role).create?).to be_truthy
      end

      it 'denies officer and member from creating a member role' do
        expect(MemberRolePolicy.new(officer, member_role).create?).to be_falsey
        expect(MemberRolePolicy.new(member, member_role).create?).to be_falsey
        expect(MemberRolePolicy.new(unapproved, member_role).create?).to be_falsey
      end
    end

    describe '#new?' do
      it 'allows admin to access new member role form' do
        expect(MemberRolePolicy.new(admin, member_role).new?).to be_truthy
      end

      it 'denies officer and member from accessing new member role form' do
        expect(MemberRolePolicy.new(officer, member_role).new?).to be_falsey
        expect(MemberRolePolicy.new(member, member_role).new?).to be_falsey
        expect(MemberRolePolicy.new(unapproved, member_role).new?).to be_falsey
      end
    end

    describe '#edit?' do
      it 'permits only admin to edit a member role' do
        expect(MemberRolePolicy.new(admin, member_role).edit?).to be_truthy
      end

      it 'denies officer and member from editing a member role' do
        expect(MemberRolePolicy.new(officer, member_role).edit?).to be_falsey
        expect(MemberRolePolicy.new(member, member_role).edit?).to be_falsey
        expect(MemberRolePolicy.new(unapproved, member_role).edit?).to be_falsey
      end
    end

    describe '#update?' do
      it 'permits only admin to update a member role' do
        expect(MemberRolePolicy.new(admin, member_role).update?).to be_truthy
      end

      it 'denies officer and member from updating a member role' do
        expect(MemberRolePolicy.new(officer, member_role).update?).to be_falsey
        expect(MemberRolePolicy.new(member, member_role).update?).to be_falsey
        expect(MemberRolePolicy.new(unapproved, member_role).update?).to be_falsey
      end
    end

    describe '#destroy?' do
      it 'allows only admin to delete a member role' do
        expect(MemberRolePolicy.new(admin, member_role).destroy?).to be_truthy
      end

      it 'prevents officer and member from deleting a member role' do
        expect(MemberRolePolicy.new(officer, member_role).destroy?).to be_falsey
        expect(MemberRolePolicy.new(member, member_role).destroy?).to be_falsey
        expect(MemberRolePolicy.new(unapproved, member_role).destroy?).to be_falsey
      end
    end

    describe '#approval?' do
      it 'checks for approval check' do
        expect(MemberRolePolicy.new(admin, member_role).approval?).to be_truthy
        expect(MemberRolePolicy.new(officer, member_role).approval?).to be_truthy
      end

      it 'denies member and unapproved member from approval check' do
        expect(MemberRolePolicy.new(member, member_role).approval?).to be_falsey
        expect(MemberRolePolicy.new(unapproved, member_role).approval?).to be_falsey
      end
    end

    describe '#admin_officer?' do
      it 'allows admin and officer to access member roles' do
        expect(MemberRolePolicy.new(admin, member_role).admin_officer?).to be_truthy
        expect(MemberRolePolicy.new(officer, member_role).admin_officer?).to be_truthy
      end

      it 'denies member and unapproved member from accessing member roles' do
        expect(MemberRolePolicy.new(member, member_role).admin_officer?).to be_falsey
        expect(MemberRolePolicy.new(unapproved, member_role).admin_officer?).to be_falsey
      end
    end
  end
end
