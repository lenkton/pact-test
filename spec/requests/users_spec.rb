# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users' do
    context 'with some users in db' do
      let!(:db_user) { create :user, :with_skills, :with_interests }

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
end
