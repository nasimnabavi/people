require 'spec_helper'

describe Trello::ArchiveProjects do
  let(:project) { create(:project) }

  context 'when labels for projects exist' do
    it 'does not set them as archived' do
      expect do
        described_class.new([project.name]).call!
      end.not_to change{ project.archived }.from(false).to true
    end
  end

  context 'when label for project does not exist' do
    it 'sets the projects as archived' do
      expect do
        described_class.new([]).call!
      end.to change{ project.reload.archived }.from(false).to true
    end
  end
end
