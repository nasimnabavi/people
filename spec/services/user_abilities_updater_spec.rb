require 'spec_helper'

describe UserAbilitiesUpdater do
  subject { described_class.new(user_data).call }
  let!(:user) { create(:user) }
  let(:user_data) { { 'email' => user.email, 'skills' => user_data_skills } }
  let(:ability1) { create(:ability, name: 'Java') }
  let(:ability2) { create(:ability, name: 'php') }

  before do
    user.abilities << ability1 << ability2
  end

  context 'user_data contains new ability' do
    let(:user_data_skills) { %w(Java php html) }

    it { expect { subject }.to change { user.abilities.count }.from(2).to(3) }

    it 'adds new ability to the user' do
      subject
      expect(user.abilities.pluck(:name)).to eq(%w(Java php html))
    end
  end

  context 'user_data contains less abilities' do
    let(:user_data_skills) { %w(Java) }

    it { expect { subject }.to change { user.abilities.count }.from(2).to(1) }

    it 'removes ability from the user' do
      subject
      expect(user.abilities.pluck(:name)).to eq(%w(Java))
    end
  end

  context 'user_data contains same abilities' do
    let(:user_data_skills) { %w(Java php) }
    it { expect { subject }.not_to change { user.abilities.count } }
    it { expect(subject).to eq(nil) }
  end

  context 'can not find user by email provided in user_data' do
    let(:user_data) { { 'email' => 'wrong email', 'skills' => ['ruby'] } }

    it { expect { subject }.not_to change { user.abilities.count } }
    it { expect(subject).to eq(nil) }
  end
end
