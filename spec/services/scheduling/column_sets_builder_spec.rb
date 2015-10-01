require 'spec_helper'

describe Scheduling::ColumnSetsBuilder do
  subject { described_class.new }

  let(:possible_columns) { %w(user role current-project from-to next-project booked notes) }
  let(:categories) do
    %w(all juniors-interns to-rotate internals in-progress in-commercial-with-due-date booked
      unavailable not-scheduled)
  end

  describe '#call' do
    it 'returns hash with keys like categories on scheduling page' do
      expect(subject.call).to be_an_instance_of(Hash)
      expect(subject.call.keys.sort).to eql(categories.sort)
      expect(subject.call.values.flatten.uniq.sort).to eql(possible_columns.sort)
    end
  end
end
