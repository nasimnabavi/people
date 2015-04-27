require 'spec_helper'

describe Trello::CardSync do
  let(:card) { double('card') }

  before do
    allow_any_instance_of(UserRepository).to receive(:find_by_full_name)
    allow_any_instance_of(ProjectsRepository).to receive(:find_or_create_by_name)

    card.stub(:name) { 'User Name' }
    card.stub(:card_labels) { [{ 'name' => 'label' }] }
  end

  context 'card has a label' do
    it 'calls AddUserToProject' do
      instance = double('AddUserToProject')
      Trello::AddUserToProject.should_receive(:new).with('User Name', ['label'])
        .and_return(instance)
      instance.should_receive(:call)

      described_class.new(card).call
    end
  end

  context 'card has more than one label' do
    it 'calls AddUserToProject with array of project names' do
      card.stub(:card_labels) do
        [
          { 'name' => 'Project 1' },
          { 'name' => 'Project 2' }
        ]
      end

      instance = double('AddUserToProject')
      expect(Trello::AddUserToProject).to receive(:new)
        .with('User Name', ['Project 1', 'Project 2']).and_return(instance)
      expect(instance).to receive(:call)

      described_class.new(card).call
    end
  end

  context 'card does not have a label' do
    it 'calls RemoveUserFromProjects' do
      card.stub(:card_labels) { [] }
      expect_any_instance_of(Trello::RemoveUserFromProjects).to receive :call
      described_class.new(card).call
    end
  end

  context 'card has an empty label' do
    it 'does not call AddUserToProject' do
      card.stub(:card_labels) { [{ 'name' => '' }] }
      expect_any_instance_of(Trello::AddUserToProject).not_to receive :call
      described_class.new(card).call
    end
  end
end
