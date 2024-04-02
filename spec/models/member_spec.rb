# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Member, type: :model) do
  # Define a valid member directly
  let(:valid_attributes) do
    {
      first_name: 'John',
      last_name: 'Doe',
      email: 'john.doe@tamu.edu',
      points: 100,
      position: 'Member',
      date_joined: Time.zone.today,
      degree: 'Bachelor',
      res_topic: 'Topic',
      res_lab: 'Lab',
      res_pioneer: 'Pioneer',
      res_description: 'Description',
      area_of_study: 'Study Area',
      food_allergies: 'None'
    }
  end

  context 'validations' do
    it 'is valid with valid attributes' do
      member = described_class.new(valid_attributes)
      expect(member).to(be_valid)
    end

    it 'is not valid without a first_name' do
      invalid_attributes = valid_attributes.merge(first_name: nil)
      member = described_class.new(invalid_attributes)
      expect(member).not_to(be_valid)
    end

    it 'is not valid without a last_name' do
      invalid_attributes = valid_attributes.merge(last_name: nil)
      member = described_class.new(invalid_attributes)
      expect(member).not_to(be_valid)
    end

    it 'is not valid without an email' do
      member = described_class.new(valid_attributes.merge(email: nil))
      expect(member).not_to(be_valid)
    end

    it 'is not valid with negative points' do
      member = described_class.new(valid_attributes.merge(points: -10))
      expect(member).not_to(be_valid)
    end

    it 'is not valid position' do
      member = described_class.new(valid_attributes.merge(position: nil))
      expect(member).not_to(be_valid)
    end

    # If none enter 'None'
    it 'is not valid without listing food_allergies' do
      member = described_class.new(valid_attributes.merge(food_allergies: nil))
      expect(member).not_to(be_valid)
    end
  end
end
