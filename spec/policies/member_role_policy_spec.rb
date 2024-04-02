# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(MemberRolePolicy, type: :policy) do
  subject { described_class }

  before do
    Rails.application.load_seed
  end

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
        expect(described_class.new(admin, member_role)).to(be_index)
      end

      it 'denies access to officer and member' do
        expect(described_class.new(officer, member_role)).not_to(be_index)
        expect(described_class.new(member, member_role)).not_to(be_index)
        expect(described_class.new(unapproved, member_role)).not_to(be_index)
      end
    end

    describe '#show?' do
      it 'allows admin to view a member role detail' do
        expect(described_class.new(admin, member_role)).to(be_show)
      end

      it 'denies access to officer and member' do
        expect(described_class.new(officer, member_role)).not_to(be_show)
        expect(described_class.new(member, member_role)).not_to(be_show)
        expect(described_class.new(unapproved, member_role)).not_to(be_show)
      end
    end

    # Repeat the structure for other actions: new?, create?, edit?, update?, destroy?

    describe '#create?' do
      it 'allows admin to create a member role' do
        expect(described_class.new(admin, member_role)).to(be_create)
      end

      it 'denies officer and member from creating a member role' do
        expect(described_class.new(officer, member_role)).not_to(be_create)
        expect(described_class.new(member, member_role)).not_to(be_create)
        expect(described_class.new(unapproved, member_role)).not_to(be_create)
      end
    end

    describe '#new?' do
      it 'allows admin to access new member role form' do
        expect(described_class.new(admin, member_role)).to(be_new)
      end

      it 'denies officer and member from accessing new member role form' do
        expect(described_class.new(officer, member_role)).not_to(be_new)
        expect(described_class.new(member, member_role)).not_to(be_new)
        expect(described_class.new(unapproved, member_role)).not_to(be_new)
      end
    end

    describe '#edit?' do
      it 'permits only admin to edit a member role' do
        expect(described_class.new(admin, member_role)).to(be_edit)
      end

      it 'denies officer and member from editing a member role' do
        expect(described_class.new(officer, member_role)).not_to(be_edit)
        expect(described_class.new(member, member_role)).not_to(be_edit)
        expect(described_class.new(unapproved, member_role)).not_to(be_edit)
      end
    end

    describe '#update?' do
      it 'permits only admin to update a member role' do
        expect(described_class.new(admin, member_role)).to(be_update)
      end

      it 'denies officer and member from updating a member role' do
        expect(described_class.new(officer, member_role)).not_to(be_update)
        expect(described_class.new(member, member_role)).not_to(be_update)
        expect(described_class.new(unapproved, member_role)).not_to(be_update)
      end
    end

    describe '#destroy?' do
      it 'allows only admin to delete a member role' do
        expect(described_class.new(admin, member_role)).to(be_destroy)
      end

      it 'prevents officer and member from deleting a member role' do
        expect(described_class.new(officer, member_role)).not_to(be_destroy)
        expect(described_class.new(member, member_role)).not_to(be_destroy)
        expect(described_class.new(unapproved, member_role)).not_to(be_destroy)
      end
    end

    describe '#approval?' do
      it 'checks for approval check' do
        expect(described_class.new(admin, member_role)).to(be_approval)
        expect(described_class.new(officer, member_role)).to(be_approval)
      end

      it 'denies member and unapproved member from approval check' do
        expect(described_class.new(member, member_role)).not_to(be_approval)
        expect(described_class.new(unapproved, member_role)).not_to(be_approval)
      end
    end

    describe '#admin_officer?' do
      it 'allows admin and officer to access member roles' do
        expect(described_class.new(admin, member_role)).to(be_admin_officer)
        expect(described_class.new(officer, member_role)).to(be_admin_officer)
      end

      it 'denies member and unapproved member from accessing member roles' do
        expect(described_class.new(member, member_role)).not_to(be_admin_officer)
        expect(described_class.new(unapproved, member_role)).not_to(be_admin_officer)
      end
    end
  end
end
