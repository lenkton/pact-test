# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = Users::List.run!
  end
end
