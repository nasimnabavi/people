require 'spec_helper'

describe Trello::RemoveUserFromProjects do
  subject { described_class }

  let!(:user) do
    create(:user, first_name: 'Other', last_name: 'Developer')
  end
  let!(:project) { create(:project) }

  around do |example|
    Timecop.freeze(Time.local(2015))
    example.run
    Timecop.return
  end

  context 'membership does not have end date' do
    let!(:membership) do
      create(
        :membership,
        project: project,
        user: user,
        ends_at: nil
      )
    end

    it 'adds end date for the membership' do
      expect do
        subject.new("#{user.first_name} #{user.last_name}").call!
      end.to change{ membership.reload.ends_at }.from(nil).to 1.day.ago.midnight
    end
  end

  context 'membership has future end date' do
    let!(:membership) do
      create(
        :membership,
        project: project,
        user: user,
        ends_at: 1.month.from_now
      )
    end

    it 'adds end date for the membership' do
      expect do
        subject.new("#{user.first_name} #{user.last_name}").call!
      end.to change{ membership.reload.ends_at }.from(membership.ends_at).to 1.day.ago.midnight
    end
  end

  context 'membership has past end date' do
    let!(:membership) do
      create(
        :membership,
        project: project,
        user: user,
        ends_at: 1.month.ago
      )
    end

    it 'does not change the membership' do
      expect do
        subject.new("#{user.first_name} #{user.last_name}").call!
      end.not_to change{ membership.reload.ends_at }
    end
  end
end
