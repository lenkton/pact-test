# frozen_string_literal: true

FactoryBot.define do
  factory :interest do
    sequence(:name) { "Interest #{_1}" }
  end
end
