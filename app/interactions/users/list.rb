# frozen_string_literal: true

module Users
  class List < ActiveInteraction::Base
    def execute
      # WARN: super dangerous and not production ready!
      User.all
    end
  end
end
