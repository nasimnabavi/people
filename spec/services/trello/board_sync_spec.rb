require 'spec_helper'

describe Trello::BoardSync do
  let(:card) { double('card') }
  let(:label) { double('label') }
  let(:board) { double('board') }

  before do
    allow_any_instance_of(Trello::CardSync).to receive(:call)
    allow_any_instance_of(Trello::LabelsSync).to receive(:call)

    allow(card).to receive_messages(name: 'User Name')
    allow(card).to receive_messages(card_labels: [{ 'name' => 'label' }])

    allow(label).to receive_messages(name: 'labelname')

    allow(board).to receive_messages(cards: [card])
    allow(board).to receive_messages(labels: [label])
  end

  describe '#call' do
    it 'synchronizes all the cards' do
      expect_any_instance_of(Trello::CardSync).to receive(:call)
      described_class.new(board).call
    end

    it 'synchronizes all the labels' do
      expect_any_instance_of(Trello::LabelsSync).to receive(:call)
      described_class.new(board).call
    end
  end
end
