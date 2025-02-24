# frozen_string_literal: true

class Interest < ApplicationRecord
  has_many :interests_users, dependent: :destroy
  has_many :users, through: :interests_users
end
