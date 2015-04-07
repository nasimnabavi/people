require 'spec_helper'

describe Trello::CreateProjectFromLabel do
  context 'when project does not exist' do
    it 'creates a new project' do
      expect do
        described_class.new('newproject').call!
      end.to change{ Project.count }.by 1
    end
  end

  context 'when a project exists' do
    it 'does not create a new project' do
      create(:project, name: 'newproject')

      expect do
        described_class.new('newproject').call!
      end.not_to change{ Project.count }
    end
  end
end
