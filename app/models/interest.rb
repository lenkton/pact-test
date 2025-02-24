# frozen_string_literal: true

class Interest < ApplicationRecord
  has_many :user_interests
  has_many :users, through: :user_interests
end
