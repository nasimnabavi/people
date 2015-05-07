require 'spec_helper'

describe CommitmentSetter do
  let(:user) { build(:user, commitment: 40) }

  context 'when correct user role name is provided' do
    it 'changes user commitment value' do
      expect do
        described_class.new(user, :senior).call
      end.to change{ user.commitment }.from(40).to(35)
    end
  end

  context 'when correct user role name is not provided' do
    it 'does not change the commitment value' do
      expect do
        described_class.new(user, :cto).call
      end.not_to change{ user.commitment }
    end
  end
end
