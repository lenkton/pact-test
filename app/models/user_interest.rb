# frozen_string_literal: true

class UserInterest < ApplicationRecord
  belong_to :user
  belong_to :interest
end
