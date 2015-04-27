require 'spec_helper'

describe Trello::AddUserToProject do
  subject { described_class.new("#{user.first_name} #{user.last_name}", [project.name]) }

  let!(:role) { create(:role_billable) }
  let!(:user) do
    create(:user, first_name: 'John', last_name: 'Doe', primary_role: role)
  end
  let!(:project) { create(:project, name: 'secondproject') }

  context 'user is not in a project' do
    it 'creates a new membership for the user' do
      expect do
        subject.call
      end.to change{ user.memberships.count }.by 1
    end

    it 'creates a membership that started yesterday' do
      subject.call
      expect(user.memberships.first.starts_at).to eq Date.yesterday
    end

    it 'creates a membership with role set to current user position' do
      subject.call
      expect(user.memberships.first.role).to eq user.primary_role
    end

    it 'does not duplicate memberships' do
      expect do
        2.times{ subject.call }
      end.to change{ user.memberships.count }.by 1
    end

    context 'invalid project name' do
      it 'does not create a new membership' do
        expect do
          described_class.new("#{user.first_name} #{user.last_name}", ['invalid name']).call
        end.not_to change{ user.memberships.count }
      end
    end
  end

  context 'user is in a project' do
    subject do
      described_class.new(
        "#{user_with_membership.first_name} #{user_with_membership.last_name}",
        [project.name]
      )
    end

    let!(:user_with_membership) do
      create(:user, first_name: 'Other', last_name: 'Developer', primary_role: role)
    end

    context 'from the label' do
      let!(:membership) { create(:membership, project: project, user: user_with_membership) }

      it 'does not create a new membership for the user' do
        expect do
          subject.call
        end.to_not change{ user_with_membership.memberships.count }.by 1
      end
    end

    context 'different project' do
      let!(:different_project) { create(:project) }
      let!(:membership) do
        create(
          :membership,
          project: different_project,
          user: user_with_membership
        )
      end

      it 'ends the existing membership' do
        expect do
          subject.call
        end.to change{ membership.reload.ends_at }.to Date.yesterday
      end

      it 'creates a new membership' do
        expect do
          subject.call
        end.to change{ user_with_membership.memberships.count }.by 1
      end
    end
  end

  context 'user does not exist' do
    it 'logs a message' do
      expect_any_instance_of(Logger).to receive(:info).with('User nonexistent user does not exist')
      described_class.new("nonexistent user", [project.name]).call
    end
  end
end
