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

  describe '#to_synchronize' do
    subject { described_class.new.to_synchronize }

    let!(:project) { create(:project) }
    let!(:not_synchronized_project) { create(:project, synchronize: false) }

    it 'return only one project' do
      expect(subject.size).to eq 1
    end

    it 'return project which should be synchronized' do
      expect(subject).to include project
    end

    it 'does not return project which should not be synchronized' do
      expect(subject).not_to include not_synchronized_project
    end
  end

  context 'project statuses' do
    let(:active_project) { create(:project) }
    let(:potential_project) { create(:project, potential: true) }
    let(:archived_project) { create(:project, archived: true) }
    let(:archived_potential_project) { create(:project, archived: true, potential: true) }

    describe '#active_with_memberships' do
      subject { described_class.new.active_with_memberships }

      it 'returns active projects' do
        expect(subject).to include active_project
      end

      it 'does not return potential projects' do
        expect(subject).not_to include potential_project
      end

      it 'does not return archived projects' do
        expect(subject).not_to include archived_project
      end

      it 'does not return archived potential projects' do
        expect(subject).not_to include archived_potential_project
      end
    end

    describe '#active' do
      subject { described_class.new.active }

      it 'returns active projects' do
        expect(subject).to include active_project
      end

      it 'does not return potential projects' do
        expect(subject).not_to include potential_project
      end

      it 'does not return archived projects' do
        expect(subject).not_to include archived_project
      end

      it 'does not return archived potential projects' do
        expect(subject).not_to include archived_potential_project
      end
    end

    describe '#potential' do
      subject { described_class.new.potential }

      it 'does not return active projects' do
        expect(subject).not_to include active_project
      end

      it 'returns potential projects' do
        expect(subject).to include potential_project
      end

      it 'does not return archived projects' do
        expect(subject).not_to include archived_project
      end

      it 'does not return archived potential projects' do
        expect(subject).not_to include archived_potential_project
      end
    end

    describe '#not_potential' do
      subject { described_class.new.not_potential }

      it 'returns active projects' do
        expect(subject).to include active_project
      end

      it 'does not return potential projects' do
        expect(subject).not_to include potential_project
      end

      it 'returns archived projects' do
        expect(subject).to include archived_project
      end

      it 'does not return archived potential projects' do
        expect(subject).not_to include archived_potential_project
      end
    end

    describe '#archived' do
      subject { described_class.new.archived }

      it 'does not return active projects' do
        expect(subject).not_to include active_project
      end

      it 'does not return potential projects' do
        expect(subject).not_to include potential_project
      end

      it 'returns archived projects' do
        expect(subject).to include archived_project
      end

      it 'returns archived potential projects' do
        expect(subject).to include archived_potential_project
      end
    end
  end
end
