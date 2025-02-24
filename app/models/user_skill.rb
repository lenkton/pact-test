# frozen_string_literal: true

class UserSkill < ApplicationRecord
  belong_to :user
  belong_to :skill
end
