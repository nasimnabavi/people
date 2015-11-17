require 'spec_helper'
require 'rake'
Hrguru::Application.load_tasks

describe "mailer namespace rake tasks" do
  before(:all) do
    Rake.application.rake_require('tasks/netguru_api/fetch_abilities')
    Rake::Task.define_task(:environment)
  end

  describe 'mailer:users_without_primary_role' do
    let(:run_rake_task) do
      Rake::Task['mailer:users_without_primary_role'].reenable
      Rake.application.invoke_task 'mailer:users_without_primary_role'
    end

    it 'doesnt send mail if everyone have role' do
      expect(SendMailJob).not_to receive(:new)
      run_rake_task
    end
  end
end
