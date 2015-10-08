require 'spec_helper'

describe Scheduling::MissingUsers do
  let!(:technical_users) { create_list(:user, 5, :developer) }
  let!(:other_technial_users) { create_list(:user, 3, :developer) }
  let(:pm_user) { create(:pm_user) }
  let(:qa_user) { create(:qa_user) }
  let(:non_technical_users) { [pm_user, qa_user] }

  subject { described_class.new(other_technial_users.map { |u| u.id }) }

  describe '#call' do
    it 'returns users that are not in the given ids list' do
      users_ids = subject.call.map(&:id).sort

      expect(users_ids.size).to_not eql(0)
      expect(other_technial_users[0].id.in?(users_ids)).to be_false
      expect(other_technial_users[1].id.in?(users_ids)).to be_false
      expect(other_technial_users[2].id.in?(users_ids)).to be_false
    end

    it 'returns users that are with technical roles as primary' do
      users = subject.call
      users_ids = users.map(&:id)

      expect(users.size).to eql(technical_users.size)
      expect(users_ids.sort).to eql(technical_users.map(&:id).sort)
      expect(pm_user.id.in?(users_ids)).to be_false
      expect(qa_user.id.in?(users_ids)).to be_false
    end
  end
end
