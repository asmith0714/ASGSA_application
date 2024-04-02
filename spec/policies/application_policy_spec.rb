# frozen_string_literal: true

# spec/policies/application_policy_spec.rb
require 'rails_helper'

RSpec.describe(ApplicationPolicy) do
  before do
    Rails.application.load_seed
  end

  let(:user) { create(:member) } # or create(:member, :admin) for an admin user
  let(:record) { Object.new } # using a generic Ruby object
  let(:policy) { described_class.new(user, record) }

  describe '#index?' do
    it 'returns false' do
      expect(policy.index?).to(eq(false))
    end
  end

  describe '#show?' do
    it 'returns false' do
      expect(policy.show?).to(eq(false))
    end
  end

  describe '#create?' do
    it 'returns false' do
      expect(policy.create?).to(eq(false))
    end
  end

  describe '#new?' do
    it 'returns the same result as #create?' do
      expect(policy.new?).to(eq(policy.create?))
    end
  end

  describe '#update?' do
    it 'returns false' do
      expect(policy.update?).to(eq(false))
    end
  end

  describe '#edit?' do
    it 'returns the same result as #update?' do
      expect(policy.edit?).to(eq(policy.update?))
    end
  end

  describe '#destroy?' do
    it 'returns false' do
      expect(policy.destroy?).to(eq(false))
    end
  end

  describe 'Scope' do
    let(:scope) { ApplicationPolicy::Scope.new(user, record) }

    describe '#resolve' do
      it 'raises a NotImplementedError' do
        expect { scope.resolve }.to(raise_error(NotImplementedError))
      end
    end
  end
end
