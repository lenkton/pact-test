# frozen_string_literal: true

class InterestsUser < ApplicationRecord
  belongs_to :user
  belongs_to :interest
end
