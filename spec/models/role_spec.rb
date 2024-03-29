# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Role, type: :model) do
  subject do
    described_class.new(
      name: 'admin',
      permissions: 'all'
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to(be_valid)
  end

  it 'is not valid without a name' do
    subject.name = nil
    expect(subject).not_to(be_valid)
  end

  it 'is not valid without permissions' do
    subject.permissions = nil
    expect(subject).not_to(be_valid)
  end
end
