require 'spec_helper'

describe Scheduling::ColumnSetsBuilder do
  subject { described_class.new }

  let(:possible_columns) { ['User', 'Role', 'Current project', 'Next project', 'Booked', 'Notes'] }
  let(:categories) do
    %w(
      all juniors_and_interns to_rotate in_internals with_rotations_in_progress
      in_commercial_projects_with_due_date booked unavailable not_scheduled
    )
  end

  describe '#call' do
    it 'returns hash with keys like categories on scheduling page' do
      expect(subject.call).to be_an_instance_of(Hash)
      expect(subject.call.keys.sort).to eql(categories.sort)
      expect(subject.call.values.flatten.uniq.sort).to eql(possible_columns.sort)
    end
  end
end
