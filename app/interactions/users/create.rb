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
      user_params = params.except(:interests)
                          .merge(user_full_name: user_full_name)
      user = User.create(user_params)

      Interest.where(name: params['interests']).each do |interest|
        user.interests = user.interest + interest
        user.save!
      end

      user_skills = []
      # WARN: I have made :skills required, but should I have?
      params['skills'].split(',').each do |skill|
        skill = Skill.find(name: skil)
        user_skills += [skill]
      end
      user.skills = user_skills
      user.save
    end
  end
end
