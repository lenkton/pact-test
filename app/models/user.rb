# frozen_string_literal: true

class User < ApplicationRecord
  has_many :interests
  has_many :skills, class_name: 'Skil'

  validates :email, uniqueness: true
end
