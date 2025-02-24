# frozen_string_literal: true

module Users
  class Create < ActiveInteraction::Base
    integer :age
    string :surname, :name, :patronymic, :email, :nationality, :country, :gender, :skills
    array :interests

    validates :age, comparison: { greater_than: 0, less_than_or_equal_to: 90 }
    validates :gender, inclusion: { in: %w[male female] }

    def execute
      # WARN: I have made :surname required, but should I have?
      user_full_name = "#{params['surname']} #{params['name']} #{params['patronymic']}"
      user_params = params.except(:interests, :skills)
                          .merge(user_full_name: user_full_name)
      interests = Interest.where(name: params['interests'])
      # WARN: I have made :skills required, but should I have?
      skills = Skill.where(name: params['skills'].split(','))

      user = User.new(user_params)

      user.interests = interests
      user.skills = skills

      user.save
    end
  end
end
