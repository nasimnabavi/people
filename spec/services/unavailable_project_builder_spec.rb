require 'spec_helper'

describe UnavailableProjectBuilder do
  subject { described_class.new }
  context 'when an "unavailable" project doesn\'t exist' do
    it 'creates an "unavailable" project' do
      expect(Project.count).to eq(0)
      expect { subject.call }.to change(Project, :count).by(1)
      expect(Project.first.name).to match(/unavailable/i)
    end

    it 'returns an "unavailable" project' do
      expect(subject.call.name).to match(/unavailable/i)
    end
  end

  context 'when an "unavailable" project exists' do
    let!(:unavailable_project) { create(:project, name: 'Unavailable') }
    it 'doesn\'t create a duplicate unavailable project' do
      expect { subject.call }.not_to change(Project, :count)
    end

    it 'returns an "unavailable" project' do
      expect(subject.call.name).to match(/unavailable/i)
    end
  end
end
