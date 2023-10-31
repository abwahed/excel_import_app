# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'First' }
    last_name { 'Last' }
    sequence(:email) { |n| "user#{n}@test.com" }
  end
end
