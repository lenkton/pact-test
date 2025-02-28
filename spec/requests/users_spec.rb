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
      include_examples 'it has the field', 'age'
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

  describe 'POST /users' do
    # @param {Symbol} param
    shared_examples 'it fails with no' do |param|
      let(:params) { valid_params.except(param) }

      it 'returns 422 Unprocessable Entity' do
        post '/users', params: params, as: :json

        expect(response.code).to eq '422'
      end

      it 'has some error message' do
        post '/users', params: params, as: :json

        expect(json['errors']).to include(
          param.to_s => ['is required']
        )
      end

      it 'creates no records in db' do
        expect { post '/users', params: params, as: :json }
          .not_to change(User, :count)
      end
    end

    let(:valid_params) do
      {
        name: 'Ivan',
        surname: 'Ivanov',
        patronymic: 'Ivanovich',
        age: 12,
        email: 'ivan@mail.test',
        nationality: 'Russian',
        country: 'Russia',
        gender: 'male',
        skills: '',
        interests: []
      }
    end

    context 'with valid params' do
      let(:params) { valid_params }

      it 'returns 201 Created' do
        post '/users', params: params, as: :json

        expect(response.code).to eq '201'
      end

      it 'creates a db entry' do
        expect { post '/users', params: params, as: :json }
          .to change(User, :count)
          .by(1)
      end

      it 'generates a user_full_name' do
        post '/users', params: params, as: :json

        expect(User.last.user_full_name)
          .to eq 'Ivanov Ivan Ivanovich'
      end

      it 'returns the user' do # rubocop:disable RSpec/ExampleLength
        post '/users', params: params, as: :json

        expect(json['user']).to eq(
          'id' => User.last.id,
          'name' => 'Ivan',
          'surname' => 'Ivanov',
          'patronymic' => 'Ivanovich',
          'age' => 12,
          'email' => 'ivan@mail.test',
          'nationality' => 'Russian',
          'country' => 'Russia',
          'gender' => 'male',
          'skills' => [],
          'interests' => []
        )
      end
    end

    context 'with interests' do
      let(:params) { valid_params.merge(interests: %w[Yoga Baseball]) }

      before do
        create :interest, name: 'Baseball'
        create :interest, name: 'Yoga'
      end

      it 'returns 201 Created' do
        post '/users', params: params, as: :json

        expect(response.code).to eq '201'
      end

      it 'creates entries in join tables' do
        expect { post '/users', params: params, as: :json }
          .to change(InterestsUser, :count)
          .by(2)
      end

      it 'has interests in the response' do
        post '/users', params: params, as: :json

        expect(json['user']).to include(
          'interests' => match_array(%w[Yoga Baseball])
        )
      end
    end

    context 'with skills' do
      let(:params) { valid_params.merge(skills: 'Java,C++') }

      before do
        create :skill, name: 'Java'
        create :skill, name: 'C++'
      end

      it 'returns 201 Created' do
        post '/users', params: params, as: :json

        expect(response.code).to eq '201'
      end

      it 'creates entries in join tables' do
        expect { post '/users', params: params, as: :json }
          .to change(SkillsUser, :count)
          .by(2)
      end

      it 'has skills in the response' do
        post '/users', params: params, as: :json

        expect(json['user']).to include(
          'skills' => contain_exactly('C++', 'Java')
        )
      end
    end

    it_behaves_like 'it fails with no', :name
    it_behaves_like 'it fails with no', :surname
    it_behaves_like 'it fails with no', :patronymic
    it_behaves_like 'it fails with no', :age
    it_behaves_like 'it fails with no', :email
    it_behaves_like 'it fails with no', :nationality
    it_behaves_like 'it fails with no', :country
    it_behaves_like 'it fails with no', :gender
    it_behaves_like 'it fails with no', :skills
    it_behaves_like 'it fails with no', :interests

    context 'with a duplicating email' do
      let(:params) { valid_params }

      before do
        create :user, email: 'ivan@mail.test'
      end

      it 'returns 422 Unprocessable Entity' do
        post '/users', params: params, as: :json

        expect(response.code).to eq '422'
      end

      it 'has some error message' do
        post '/users', params: params, as: :json

        expect(json['errors']).to include(
          'email' => ['has already been taken']
        )
      end

      it 'creates no records in db' do
        expect { post '/users', params: params, as: :json }
          .not_to change(User, :count)
      end
    end

    context 'with negative age' do
      let(:params) { valid_params.merge(age: -1) }

      it 'returns 422 Unprocessable Entity' do
        post '/users', params: params, as: :json

        expect(response.code).to eq '422'
      end

      it 'has some error message' do
        post '/users', params: params, as: :json

        expect(json['errors']).to include(
          'age' => ['must be greater than 0']
        )
      end

      it 'creates no records in db' do
        expect { post '/users', params: params, as: :json }
          .not_to change(User, :count)
      end
    end

    context 'with age of 0' do
      let(:params) { valid_params.merge(age: 0) }

      it 'returns 422 Unprocessable Entity' do
        post '/users', params: params, as: :json

        expect(response.code).to eq '422'
      end

      it 'has some error message' do
        post '/users', params: params, as: :json

        expect(json['errors']).to include(
          'age' => ['must be greater than 0']
        )
      end

      it 'creates no records in db' do
        expect { post '/users', params: params, as: :json }
          .not_to change(User, :count)
      end
    end

    context 'with age > 90' do
      let(:params) { valid_params.merge(age: 91) }

      it 'returns 422 Unprocessable Entity' do
        post '/users', params: params, as: :json

        expect(response.code).to eq '422'
      end

      it 'has some error message' do
        post '/users', params: params, as: :json

        expect(json['errors']).to include(
          'age' => ['must be less than or equal to 90']
        )
      end

      it 'creates no records in db' do
        expect { post '/users', params: params, as: :json }
          .not_to change(User, :count)
      end
    end

    context 'with some unknown gender' do
      let(:params) { valid_params.merge(gender: 'fxmale') }

      it 'returns 422 Unprocessable Entity' do
        post '/users', params: params, as: :json

        expect(response.code).to eq '422'
      end

      it 'has some error message' do
        post '/users', params: params, as: :json

        expect(json['errors']).to include(
          'gender' => ['is not included in the list']
        )
      end

      it 'creates no records in db' do
        expect { post '/users', params: params, as: :json }
          .not_to change(User, :count)
      end
    end
  end
end
