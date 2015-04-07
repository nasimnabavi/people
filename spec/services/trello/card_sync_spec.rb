require 'spec_helper'

describe Trello::CardSync do
  before do
    allow_any_instance_of(UserRepository).to receive(:find_by_full_name)
    allow_any_instance_of(ProjectsRepository).to receive(:find_or_create_by_name)
  end

  context 'card has a label' do
    it 'calls AddUserToProject' do
      instance = double('AddUserToProject')
      Trello::AddUserToProject.should_receive(:new).with('User Name', 'label')
        .and_return(instance)
      instance.should_receive(:call!)

      card = double('card')
      card.stub(:name) { 'User Name' }
      card.stub(:card_labels) { [{ 'name' => 'label' }] }

      described_class.new(card).call!
    end
  end

  context 'card does not have a label' do
    it 'calls RemoveUserFromProjects' do
      expect_any_instance_of(Trello::RemoveUserFromProjects).to receive :call!

      card = double('card')
      card.stub(:name)
      card.stub(:card_labels) { [] }

      described_class.new(card).call!
    end
  end
end
