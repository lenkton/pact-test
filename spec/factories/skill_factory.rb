# frozen_string_literal: true

FactoryBot.define do
  factory :skill do
    sequence(:name) { "Skill #{n}" }
  end
end
