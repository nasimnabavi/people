require 'spec_helper'

describe SavePosition do
  let(:user) { create(:user) }
  let(:position) { build(:position, user: user) }

  subject { described_class.new(position).call }

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
end
