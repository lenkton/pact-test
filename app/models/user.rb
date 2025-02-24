# frozen_string_literal: true

class User < ApplicationRecord
  has_many :interests_users, dependent: :destroy
  has_many :interests, through: :interests_users
  has_many :skills_users, dependent: :destroy
  has_many :skills, through: :skills_users

  validates :email, uniqueness: true
end
