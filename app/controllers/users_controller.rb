# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = Users::List.run!
  end

  def show
    outcome = Users::Find.run(id: params[:id])

    if outcome.valid?
      @user = outcome.result
    else
      render json: { errors: outcome.errors }, status: :not_found
    end
  end
end
