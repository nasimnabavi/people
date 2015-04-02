require 'spec_helper'

describe Trello::BoardSync do
  describe '#call' do
    it 'synchronizes all the cards' do
      expect_any_instance_of(Trello::CardSync).to receive(:call!)

      card = double('card')
      card.stub(:name) { 'User Name' }
      card.stub(:card_labels) { [{ 'name' => 'label' }] }

      board = double('board')
      board.stub(:cards) { [card] }

      described_class.new(board).call!
    end
  end
end
