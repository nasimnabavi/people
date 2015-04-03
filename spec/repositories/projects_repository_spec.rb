require 'spec_helper'

describe ProjectsRepository do
  subject { described_class }

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
