# frozen_string_literal: true

# spec/policies/role_policy_spec.rb
require 'rails_helper'

RSpec.describe(RolePolicy) do
  subject { described_class }

  before do
    Rails.application.load_seed
  end

  let(:admin) { create(:member, :admin) }
  let(:member) { create(:member) }

  permissions :index?, :show?, :new?, :create?, :edit?, :update?, :destroy? do
    it 'grants access if user is an admin' do
      expect(subject).to(permit(admin))
    end

    it 'denies access if user is not an admin' do
      expect(subject).not_to(permit(member))
    end
  end
end
