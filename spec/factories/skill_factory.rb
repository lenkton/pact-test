# frozen_string_literal: true

FactoryBot.define do
  factory :skill do
    sequence(:name) { "Skill #{_1}" }
  end
end
