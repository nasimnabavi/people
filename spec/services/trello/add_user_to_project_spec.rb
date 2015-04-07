require 'spec_helper'

describe Trello::AddUserToProject do
  subject { described_class.new("#{user.first_name} #{user.last_name}", project.name) }

  let!(:role) { create(:role_billable) }
  let!(:user) do
    create(:user, first_name: 'John', last_name: 'Doe', primary_role: role)
  end
  let!(:project) { create(:project, name: 'secondproject') }

  context 'user is not in a project' do
    it 'creates a new membership for the user' do
      expect do
        subject.call!
      end.to change{ user.memberships.count }.by 1
    end

    it 'creates a membership that started yesterday' do
      subject.call!
      expect(user.memberships.first.starts_at).to eq 1.day.ago.midnight
    end

    it 'creates a membership with role set to current user position' do
      subject.call!
      expect(user.memberships.first.role).to eq user.primary_role
    end
  end

  context 'user is in a project' do
    let!(:user_with_membership) do
      create(:user, first_name: 'Other', last_name: 'Developer', primary_role: role)
    end
    let!(:membership) { create(:membership, project: project, user: user_with_membership) }

    it 'does not create a new membership for the user' do
      expect do
        subject.call!
      end.to_not change{ user_with_membership.memberships.count }.by 1
    end
  end
end
