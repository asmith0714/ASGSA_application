# frozen_string_literal: true

# spec/factories/members.rb
FactoryBot.define do
  factory :member do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email) { |n| "#{Faker::Internet.username(specifier: 5..8)}#{n}@tamu.edu" }
    avatar_url { 'https://example.com/image.jpg' }
    points { 100 }
    date_joined { Time.zone.today }
    degree { 'Bachelor' }
    food_allergies { 'None' }
    position { 'Member' }

    trait :admin do
      position { 'Admin' }
    end

    trait :officer do
      position { 'Officer' }
    end

    after(:create) do |member, _evaluator|
      role_id = Role.find_by(name: member.position).id
      MemberRole.create!(member_id: member.member_id, role_id: role_id)
    end
  end
end
