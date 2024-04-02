# frozen_string_literal: true

# spec/models/member_role_spec.rb
require 'rails_helper'

RSpec.describe(MemberRole, type: :model) do
  before do
    Rails.application.load_seed
  end

  describe '#at_least_one_admin' do
    let!(:admin_role) { Role.find_by(name: 'Admin') }
    let!(:user_role) { Role.find_by(name: 'Member') }
    let!(:member) { create(:member, :admin) }
    let!(:member_role) { described_class.find_by(member: member, role: admin_role) }

    context 'when there is only one admin' do
      it 'adds an error if trying to remove the admin role from the member' do
        member_role.role = user_role
        member_role.save!
        expect(member_role.errors[:role]).to(include('At least one user must be an admin at all times'))
      end
    end

    context 'when there are multiple admins' do
      let!(:another_member) { create(:member, :admin) }
      let!(:another_member_role) { described_class.find_by(member: another_member, role: admin_role) }

      it 'does not add an error if trying to remove the admin role from one of the members' do
        member_role.role = user_role
        member_role.save!
        expect(member_role.errors[:role]).to(be_empty)
      end
    end
  end
end
