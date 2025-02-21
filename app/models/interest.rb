# frozen_string_literal: true

class Interest < ApplicationRecord
  has_many :users
end
