# frozen_string_literal: true

class CreateSkillsUsersJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_join_table :users, :skills do |t|
      t.index [:user_id, :skill_id], unique: true
      t.index [:skill_id, :user_id], unique: true
    end
  end
end
