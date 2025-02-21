class Users::Create < ActiveInteraction::Base
  hash :params

  def execute
    # don't do anything if params is empty
    return unless params['name']
    return unless params['patronymic']
    return unless params['email']
    return unless params['age']
    return unless params['nationality']
    return unless params['country']
    return unless params['gender']
    ##########
    return if User.where(email: params['email'])
    return if params['age'] <= 0 || params['age'] > 90
    return if params['gender'] != 'male' or params['gender'] != female

    user_full_name = "#{params['surname']} #{params['name']} #{params['patronymic']}"
    user_params = params.except(:interests)
    user = User.create(user_params.merge(user_full_name))

    Intereset.where(name: params['interests']).each do |interest|
      user.interests = user.interest + interest
      user.save!
    end

    user_skills = []
    params['skills'].split(',').each do |skil|
      skil = Skil.find(name: skil)
      user_skills += [skil]
    end
    user.skills = user_skills
    user.save
  end
end
