# frozen_string_literal: true

module Users
  class Create < ActiveInteraction::Base
    integer :age
    # WARN: I have made :surname and :skills required, but should I have?
    string :surname, :name, :patronymic, :email, :nationality, :country, :gender, :skills
    array :interests

    validates :age, comparison: { greater_than: 0, less_than_or_equal_to: 90 }
    validates :gender, inclusion: { in: %w[male female] }

    def execute
      interests_relation = Interest.where(name: interests)
      skills_relation = Skill.where(name: skills.split(','))

      user = User.new(user_params)

      user.interests = interests_relation
      user.skills = skills_relation

      user.save
    end

    private

    def user_params # rubocop:disable Metrics/MethodLength
      {
        age: age,
        name: name,
        surname: surname,
        patronymic: patronymic,
        email: email,
        nationality: nationality,
        country: country,
        gender: gender,
        user_full_name: user_full_name
      }
    end

    def user_full_name
      "#{surname} #{name} #{patronymic}"
    end
  end
end
