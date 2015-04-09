require 'spec_helper'

describe ProjectsRepository do
  subject { described_class }

  describe '#ending_in_a_week' do
    subject { described_class.new.ending_in_a_week }

    let(:project) { create(:project, end_at: 1.week.from_now.midnight) }
    let(:project_ending_late) { create(:project, end_at: 2.weeks.from_now) }
    let(:inactive_project) { create(:project, end_at: 1.week.from_now, archived: true) }

    it 'returns projects ending in a week' do
      expect(subject).to include project
    end

    it 'does not return projects ending later' do
      expect(subject).not_to include project_ending_late
    end

    it 'returns only active projects' do
      expect(subject).not_to include inactive_project
    end
  end

  describe '#find_or_create_by_name' do
    context 'project already exists' do
      let(:project) { create(:project) }

      it 'finds existing project' do
        expect(
          subject.new.find_or_create_by_name(project.name).name
        ).to eq project.name
      end
    end

    context 'project does not exist' do
      it 'creates a new project with given name' do
        expect do
          subject.new.find_or_create_by_name 'people'
        end.to change{ Project.count }.by 1
      end

      it 'sets project type to regular' do
        expect(
          subject.new.find_or_create_by_name('people').project_type
        ).to eq 'regular'
      end
    end
  end
end
