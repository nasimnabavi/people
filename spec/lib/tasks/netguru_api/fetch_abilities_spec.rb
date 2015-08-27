require 'spec_helper'
require 'rake'

describe 'netguru_api:profile namespace rake tasks' do
  before(:all) do
    Rake.application.rake_require('tasks/netguru_api/fetch_abilities')
    Rake::Task.define_task(:environment)
  end

  describe 'netguru_api:profile:fetch_users_abilities' do
    let(:run_rake_task) do
      Rake::Task['netguru_api:profile:fetch_users_abilities'].reenable
      Rake.application.invoke_task 'netguru_api:profile:fetch_users_abilities'
    end

    let(:user) { create(:user, email: 'user@email.com') }
    let(:ability) { create(:ability, name: 'ruby') }

    let(:users_data) do
      [{ 'email' => 'user@email.com', 'skills' => %w(ruby javascript php) }]
    end

    before do
      allow(NetguruApi::Profile).to receive(:fetch_users_with_skills).and_return(users_data)
      user.abilities << ability
    end

    it 'updates users abilities' do
      expect(user.abilities.pluck(:name)).to eq(%w(ruby))
      run_rake_task
      expect(user.abilities.pluck(:name)).to eq(%w(ruby javascript php))
    end
  end
end
