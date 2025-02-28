# frozen_string_literal: true

FactoryBot.define do
  factory :interest do
    sequence(:name) { "Interest #{n}" }
  end
end
