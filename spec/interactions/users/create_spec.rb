# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Create, type: :interaction do
  subject(:outcome) { described_class.run(params) }

  let(:valid_params) do
    {
      age: 12,
      name: 'Ivan',
      surname: 'Ivanov',
      patronymic: 'Ivanovich',
      email: 'ivan@mail.test',
      nationality: 'Russian',
      country: 'Russia',
      gender: 'male',
      skills: '',
      interests: []
    }
  end

  # @param {Symbol} param
  shared_examples 'it requires' do |param|
    let(:params) { valid_params.except(param) }

    context "without #{param}" do
      it 'is not valid' do
        expect(outcome).not_to be_valid
      end

      it 'adds a message' do
        expect(outcome.errors.full_messages)
          .to include("#{param.to_s.capitalize} is required")
      end
    end
  end

  context 'with valid parameters' do
    let(:params) { valid_params }

    it 'is valid' do
      expect(outcome).to be_valid
    end

    it 'creates a user in db' do
      expect { described_class.run(params) }
        .to change(User, :count)
        .by(1)
    end

    it 'returns the new record' do
      expect(outcome.result).to eq User.last
    end

    it 'generates full name' do
      expect(outcome.result.user_full_name)
        .to eq 'Ivanov Ivan Ivanovich'
    end
  end

  context 'with skills' do
    let(:params) { valid_params.merge(skills: 'C++,Java,Go') }

    before do
      create :skill, name: 'C++'
      create :skill, name: 'Java'
      create :skill, name: 'Go'
    end

    it 'is valid' do
      expect(outcome).to be_valid
    end

    it 'creates connections in db' do
      expect { described_class.run(params) }
        .to change(SkillsUser, :count)
        .by(3)
    end
  end

  context 'with interests' do
    let(:params) { valid_params.merge(interests: %w[Atata Bobobo]) }

    before do
      create :interest, name: 'Atata'
      create :interest, name: 'Bobobo'
    end

    it 'is valid' do
      expect(outcome).to be_valid
    end

    it 'creates connections in db' do
      expect { described_class.run(params) }
        .to change(InterestsUser, :count)
        .by(2)
    end
  end

  it_behaves_like 'it requires', :age
  it_behaves_like 'it requires', :name
  it_behaves_like 'it requires', :surname
  it_behaves_like 'it requires', :patronymic
  it_behaves_like 'it requires', :email
  it_behaves_like 'it requires', :nationality
  it_behaves_like 'it requires', :country
  it_behaves_like 'it requires', :gender
  it_behaves_like 'it requires', :skills
  it_behaves_like 'it requires', :interests

  context 'with some unknown gender' do
    let(:params) { valid_params.merge(gender: 'fxmale') }

    it 'is invalid' do
      expect(outcome).not_to be_valid
    end

    it 'returns an error' do
      expect(outcome.errors.full_messages)
        .to include('Gender is not included in the list')
    end
  end

  context 'with an email that has already been taken' do
    let(:params) { valid_params }

    before do
      create :user, email: params[:email]
    end

    it 'is invalid' do
      expect(outcome).not_to be_valid
    end

    it 'returns an error' do
      expect(outcome.errors.full_messages)
        .to include('Email has already been taken')
    end
  end

  context 'with negative age' do
    let(:params) { valid_params.merge(age: -3) }

    it 'is invalid' do
      expect(outcome).not_to be_valid
    end

    it 'returns an error' do
      expect(outcome.errors.full_messages)
        .to include('Age must be greater than 0')
    end
  end

  context 'with age of 0' do
    let(:params) { valid_params.merge(age: 0) }

    it 'is invalid' do
      expect(outcome).not_to be_valid
    end

    it 'returns an error' do
      expect(outcome.errors.full_messages)
        .to include('Age must be greater than 0')
    end
  end

  context 'with too old people' do
    let(:params) { valid_params.merge(age: 666) }

    it 'is invalid' do
      expect(outcome).not_to be_valid
    end

    it 'returns an error' do
      expect(outcome.errors.full_messages)
        .to include('Age must be less than or equal to 90')
    end
  end
end
