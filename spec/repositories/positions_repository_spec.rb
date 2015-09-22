require 'spec_helper'

describe PositionsRepository do
  subject { described_class }

  describe '#primary' do
    let!(:primary_positions) { create_list(:position, 3, :primary) }
    let!(:positions) { create_list(:position, 5) }

    it 'returns only positions with primary set to true' do
      fetched_positions = subject.new.primary
      expect(fetched_positions.size).to eql(3)
      expect(fetched_positions.to_a).to eql(primary_positions)
    end

    it 'returns no data when no primary positions' do
      Position.where(primary: true).destroy_all
      expect(subject.new.primary.size).to eql(0)
    end
  end
end
