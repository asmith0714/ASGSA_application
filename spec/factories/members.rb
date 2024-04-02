# spec/factories/members.rb
FactoryBot.define do
    factory :member do
        first_name { Faker::Name.first_name }
        last_name { Faker::Name.last_name }
        sequence(:email) { |n| "#{Faker::Internet.username(specifier: 5..8)}#{n}@tamu.edu" }
        avatar_url { "https://example.com/image.jpg" }
        points { 100 }
        date_joined { Date.today }
        degree { "MS" }
        food_allergies { "None" }
        position { "Member" }
        status { "Active" }
        transient do
            role { "Member" }
          end

        trait :admin do
            transient do
                role { "Admin" }
            end
        end
    
        trait :officer do
            transient do
                role { "Officer" }
            end
        end

        trait :unapproved do
            transient do
                role { "Unapproved" }
            end
        end
    
        after(:create) do |member, evaluator|
            role_id = Role.find_by(name: evaluator.role).id
            MemberRole.create!(member_id: member.member_id, role_id: role_id)
        end

    end
end