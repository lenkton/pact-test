# frozen_string_literal: true

class Skill < ApplicationRecord
  has_many :skills_users, dependent: :destroy
  has_many :users, through: :skills_users
end
