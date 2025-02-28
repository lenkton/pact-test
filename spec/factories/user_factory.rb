# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    age { Faker::Number.between(from: 1, to: 90) }
    name { Faker::Name.name }
    surname { Faker::Name.last_name }
    patronymic { Faker::Name.middle_name }
    email { Faker::Internet.email }
    nationality { Faker::Nation.nationality }
    country { Faker::Address.country }
    gender { %w[male female].sample }
    skills { [] }
    interests { [] }
  end
end
