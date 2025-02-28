# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  # @param {String} param
  shared_examples 'it has the field' do |field|
    it "has the field #{field}" do
      expect(user[field]).to eq db_user.send(field)
    end
  end

  describe 'GET /users' do
    context 'with some users in db' do
      let!(:db_user) { create :user }

      before do
        get '/users'
      end

      it 'responds with 200 OK' do
        expect(response.code).to eq '200'
      end

      it 'returns some collection' do
        expect(json['users']).to be_instance_of(Array)
      end

      describe 'the collection element' do
        subject(:user) { json['users'].first }

        it 'has the id field' do
          expect(user['id']).to eq db_user.id
        end

        it 'has the name field' do
          expect(user['name']).to eq db_user.name
        end

        it 'has the surname field' do
          expect(user['surname']).to eq db_user.surname
        end

        it 'has the email field' do
          expect(user['email']).to eq db_user.email
        end
      end
    end
  end

  describe 'GET /users/:id' do
    context 'with a valid id' do
      subject(:user) { json['user'] }

      let(:java) { create :skill, name: 'Java' }
      let(:cpp) { create :skill, name: 'C++' }

      let(:baseball) { create :interest, name: 'Baseball' }
      let(:yoga) { create :interest, name: 'Yoga' }

      let(:db_user) do
        create :user,
               skills: [java, cpp],
               interests: [baseball, yoga]
      end

      before do
        get "/users/#{db_user.id}"
      end

      it 'responds with 200 OK' do
        expect(response.code).to eq '200'
      end

      include_examples 'it has the field', 'id'
      include_examples 'it has the field', 'name'
      include_examples 'it has the field', 'surname'
      include_examples 'it has the field', 'patronymic'
      include_examples 'it has the field', 'email'
      include_examples 'it has the field', 'nationality'
      include_examples 'it has the field', 'country'
      include_examples 'it has the field', 'gender'

      it 'has the skills field' do
        expect(user['skills']).to contain_exactly('C++', 'Java')
      end

      it 'has the interests field' do
        expect(user['interests']).to contain_exactly('Baseball', 'Yoga')
      end
    end

    context 'with an invalid id' do
      before do
        get '/users/666'
      end

      it 'responds with 404 Not Found' do
        expect(response.code).to eq '404'
      end

      it 'returns some error message' do
        expect(json).to eq('errors' => { 'id' => ['not found'] })
      end
    end
  end
end
