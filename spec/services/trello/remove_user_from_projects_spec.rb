require 'spec_helper'

describe Trello::RemoveUserFromProjects do
  subject { described_class }

  let!(:user) do
    create(:user, first_name: 'Other', last_name: 'Developer')
  end
  let!(:project) { create(:project) }
  let!(:membership) do
    create :membership,
           project: project,
           user: user,
           ends_at: nil
  end

  it 'adds end date for the membership' do
    expect do
      subject.new("#{user.first_name} #{user.last_name}").call!
    end.to change{ membership.reload.ends_at }.from(nil).to 1.day.ago.midnight
  end
end
