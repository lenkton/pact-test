# frozen_string_literal: true

class CreateInterestsUsersJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_join_table :users, :interests do |t|
      t.index [:user_id, :interest_id], unique: true
      t.index [:interest_id, :user_id], unique: true
    end
  end
end
