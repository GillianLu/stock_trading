require 'faker'

FactoryBot.define do
    factory :user do
      email { Faker::Internet.email }
      password { 'password' }
      first_name { Faker::Name.first_name.gsub(/\d/, '') }
      last_name { Faker::Name.last_name.gsub(/\d/, '')}
      address { Faker::Address.street_address }
      balance { 1000 }
      confirmed_at { Time.now } 
    end

    trait :admin do
      role { :admin }
    end

    trait :trader do
      role { :trader }
    end

    trait :user do
      role { :user }
    end
end