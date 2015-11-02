require 'spec_helper'

describe UserEventsRepository do
  let(:membership) { create :membership }
  let(:user) { membership.user }
  let(:project) { membership.project }
  let(:user_memberships_repository) { UserMembershipsRepository.new(user) }

  describe '#all' do
    subject { described_class.new(user_memberships_repository).all }

    it 'returns id of project under id key' do
      expect(subject.first[:id]).to eq project.id.to_s
    end

    it 'returns name of project under text key' do
      expect(subject.first[:text]).to eq project.name
    end

    it 'returns user id under user_id key' do
      expect(subject.first[:user_id]).to eq user.id.to_s
    end
  end
end
