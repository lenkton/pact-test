# frozen_string_literal: true

class SkillsUser < ApplicationRecord
  belongs_to :user
  belongs_to :skill
end
