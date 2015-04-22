require 'spec_helper'

describe UpdateUser do
  let(:user) { create(:user) }
  let(:params) do
    {
      'first_name' => 'John',
      'ability_ids' => ['']
    }
  end

  it 'updates user attributes' do
    expect do
      described_class.new(user, params).call
    end.to change{ user.first_name }.from(user.first_name).to(params['first_name'])
  end

  context 'new ability' do
    it 'creates new abilities' do
      params['ability_ids'] << 'rails'

      expect do
        described_class.new(user, params).call
      end.to change{ user.abilities.count }.from(0).to(1)
    end
  end

  context 'ability removed' do
    it 'removes existing ability from the user' do
      user.abilities << create(:ability)

      expect do
        described_class.new(user, params).call
      end.to change{ user.abilities.count }.from(1).to(0)
    end
  end
end
