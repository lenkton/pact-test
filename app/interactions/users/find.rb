# frozen_string_literal: true

module Users
  class Find < ActiveInteraction::Base
    integer :id

    def execute
      user = User.find_by(id: id)

      user || errors.add(:id, 'not found')
    end
  end
end
