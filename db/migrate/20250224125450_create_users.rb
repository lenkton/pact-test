# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def change # rubocop:disable Metrics/MethodLength
    create_table :users do |t|
      t.integer :age
      t.string :surname
      t.string :name
      t.string :patronymic
      t.string :user_full_name
      t.string :email
      t.string :nationality
      t.string :country
      t.string :gender

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
