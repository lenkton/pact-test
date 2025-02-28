# frozen_string_literal: true

module Helpers
  module Json
    def json
      JSON.parse(response.body)
    end
  end
end
