# frozen_string_literal: true

json.user do
  json.id @user.id
  json.name @user.name
  json.surname @user.surname
  json.patronymic @user.patronymic
  json.email @user.email
  json.nationality @user.nationality
  json.country @user.country
  json.gender @user.gender
  json.skills @user.skills.map(&:name)
  json.interests @user.interests.map(&:name)
end
