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
  end
end
