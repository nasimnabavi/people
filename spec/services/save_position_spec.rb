require 'spec_helper'

describe SavePosition do
  let(:user) { create(:user) }
  let(:position) { build(:position, user: user) }

  subject { SavePosition.new(position).call }

  context 'valid position' do
    it 'creates a new position' do
      expect { subject }.to change(Position, :count).by 1
    end

    it 'returns true' do
      expect(subject).to be_true
    end
  end

  context 'invalid position' do
    before { position.user = nil }

    it 'does not create a new position' do
      expect { subject }.not_to change(Position, :count)
    end

    it 'returns false' do
      expect(subject).to be_false
    end
  end

  context 'for junior developer' do
    before { position.role = create(:junior_role) }

    it 'sets commitment to 40 hours' do
      expect { subject }.to change{ user.reload.commitment }.to 40
    end
  end

  context 'for developer' do
    before { position.role = create(:dev_role) }

    it 'sets commitment to 38 hours' do
      expect { subject }.to change{ user.reload.commitment }.to 38
    end
  end

  context 'for senior developer' do
    before { position.role = create(:senior_role) }

    it 'sets commitment to 38 hours' do
      expect { subject }.to change{ user.reload.commitment }.to 35
    end
  end
end
