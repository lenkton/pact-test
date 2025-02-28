# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Find, type: :interaction do
  subject(:outcome) { described_class.run(params) }

  let(:user) { create :user }
  let(:valid_params) { { id: user.id } }

  context 'with valid parameters' do
    let(:params) { valid_params }

    it 'is valid' do
      expect(outcome).to be_valid
    end

    it 'returns the user' do
      expect(outcome.result).to eq user
    end
  end

  context 'with an invalid id' do
    let(:params) { { id: -12 } }

    it 'is invalid' do
      expect(outcome).not_to be_valid
    end

    it 'returns an error' do
      expect(outcome.errors.full_messages)
        .to include('Id not found')
    end
  end

  context 'without an id' do
    let(:params) { {} }

    it 'is valid' do
      expect(outcome).not_to be_valid
    end

    it 'returns an error' do
      expect(outcome.errors.full_messages)
        .to include('Id is required')
    end
  end
end
