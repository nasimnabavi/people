require 'spec_helper'

describe Api::V2::UserSerializer do
  let!(:project) { create(:project) }
  let!(:membership) { create(:membership, project: project, user: object) }
  let!(:object) do
    create(:user, uid: 123456, email: 'some@email.com', first_name: 'John',
      last_name: 'Doe', gh_nick: 'johnD', archived: false)
  end

  attributes = %w(uid email first_name last_name gh_nick archived)
  include_examples 'attributes', attributes

  describe 'assosciations' do
    let(:hash) { described_class.new(object).serializable_hash }

    it 'returns membership with project name' do
      expect(hash[:memberships][0][:project_name]).to eq(project.name)
    end

    context 'when there are two memberships with same project' do
      let!(:some_user) { create(:user) }
      let!(:project) { create(:project) }
      let!(:membership1) do
        create(:membership, user: some_user, project: project,
          starts_at: 6.months.ago, ends_at: 4.months.ago)
      end
      let!(:membership2) do
        create(:membership, user: some_user, project: project,
          starts_at: 3.months.ago, ends_at: 1.months.ago)
      end
      let(:hash) { described_class.new(some_user).serializable_hash }

      it 'returns only one, newset membership' do
        expect(hash[:memberships][0][:starts_at]).to eq(membership2.starts_at)
        expect(hash[:memberships][0][:ends_at]).to eq(membership2.ends_at)
        expect(hash[:memberships][0][:role]).to eq(membership2.role.name)
      end
    end
  end
end
