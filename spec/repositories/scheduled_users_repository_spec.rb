require 'spec_helper'

describe ScheduledUsersRepository do
  let!(:intern) { create(:user, :intern) }
  let!(:junior) { create(:user, :junior) }
  let!(:commercial_project_without_due_date) do
    project = create(:project, :without_due_date, :commercial)
    build(:scheduled_users_hash, project: project)
  end
  let!(:commercial_project_with_due_date) do
    project = create(:project, :commercial)
    build(:scheduled_users_hash, project: project)
  end
  let!(:internal_project) do
    project = create(:project, :internal)
    build(:scheduled_users_hash, project: project)
  end
  let!(:unavailable) do
    project = UnavailableProjectBuilder.new.call
    build(:scheduled_users_hash, project: project)
  end

  describe '#scheduled_juniors_and_interns' do
    before do
      create(:membership, user: intern,  project: create(:project))
      create(:membership, user: junior,  project: create(:project))
    end

    subject { described_class.new.scheduled_juniors_and_interns }

    it 'includes juniors and interns' do
      expect(subject).to include(junior)
      expect(subject).to include(intern)
    end

    it 'doesn\'t include others' do
      expect(subject.length).to eq(2)
    end
  end

  describe '#to_rotate' do
    subject { described_class.new.to_rotate }

    it 'includes a dev without a due date in a commercial project without due date who has' \
      ' nothing scheduled' do
      expect(subject).to include(
        commercial_project_without_due_date[:dev_without_due_date][:with_nothing_scheduled])
    end

    # TODO fix specs after bug fixes
    xit 'includes a dev without a due date in a commercial project without due date who has' \
      ' an internal project scheduled' do
      expect(subject).to include(
        commercial_project_without_due_date[:dev_without_due_date][
          :with_internal_project_scheduled])
    end

    it 'doesn\'t include others' do
      expect(subject.length).to eq(2)
    end
  end

  describe '#in_internals' do
    subject { described_class.new.in_internals }

    it 'includes devs in internal projects with nothing scheduled' do
      expect(subject).to include(
        internal_project[:dev_without_due_date][:with_nothing_scheduled])
      expect(subject).to include(
        internal_project[:dev_with_due_date][:with_nothing_scheduled])
    end

    it 'includes devs in internal projects with internal projects scheduled' do
      expect(subject).to include(
        internal_project[:dev_without_due_date][:with_internal_project_scheduled])
      expect(subject).to include(
        internal_project[:dev_with_due_date][:with_internal_project_scheduled])
      expect(subject).to include(
        unavailable[:dev_with_due_date][:with_internal_project_scheduled])
    end

    it 'doesn\'t include others' do
      expect(subject.length).to eq(5)
    end
  end

  describe '#with_rotations_in_progress' do
    subject { described_class.new.with_rotations_in_progress }

    it 'includes any dev in a project who has a commercial project scheduled' do
      expect(subject).to include(
        commercial_project_without_due_date[:dev_without_due_date][
          :with_commercial_project_scheduled])
      expect(subject).to include(
        commercial_project_without_due_date[:dev_with_due_date][
          :with_commercial_project_scheduled])
      expect(subject).to include(
        commercial_project_with_due_date[:dev_without_due_date][
          :with_commercial_project_scheduled])
      expect(subject).to include(
        commercial_project_with_due_date[:dev_with_due_date][:with_commercial_project_scheduled])
      expect(subject).to include(
        internal_project[:dev_without_due_date][:with_commercial_project_scheduled])
      expect(subject).to include(
        internal_project[:dev_with_due_date][:with_commercial_project_scheduled])
      expect(subject).to include(
        unavailable[:dev_with_due_date][:with_commercial_project_scheduled])
    end

    it 'doesn\'t include others' do
      expect(subject.length).to eq(7)
    end
  end

  describe '#in_commercial_projects_with_due_date' do
    subject { described_class.new.in_commercial_projects_with_due_date }

    it 'includes a dev with a due date in a commercial project without a due date ' \
      'who has nothing scheduled' do
      expect(subject).to include(
        commercial_project_without_due_date[:dev_with_due_date][:with_nothing_scheduled])
    end

    it 'includes a dev with a due date in a commercial project without a due date ' \
      'who has an internal project scheduled' do
      expect(subject).to include(
        commercial_project_without_due_date[:dev_with_due_date][:with_internal_project_scheduled])
    end

    it 'includes devs in a commercial project with a due date who have nothing scheduled' do
      expect(subject).to include(
        commercial_project_with_due_date[:dev_without_due_date][:with_nothing_scheduled])
      expect(subject).to include(
        commercial_project_with_due_date[:dev_with_due_date][:with_nothing_scheduled])
    end

    it 'includes devs in a commercial project with a due date ' \
      'who have internal memberships scheduled' do
      expect(subject).to include(
        commercial_project_with_due_date[:dev_without_due_date][:with_internal_project_scheduled])
      expect(subject).to include(
        commercial_project_with_due_date[:dev_with_due_date][:with_internal_project_scheduled])
    end

    it 'doesn\'t include others' do
      expect(subject.length).to eq(6)
    end
  end

  describe '#booked' do
    subject { described_class.new.booked }

    it 'includes all booked devs' do
      expect(subject).to include(
        commercial_project_without_due_date[:dev_without_due_date][:booked])
      expect(subject).to include(
        commercial_project_without_due_date[:dev_with_due_date][:booked])
      expect(subject).to include(
        commercial_project_with_due_date[:dev_without_due_date][:booked])
      expect(subject).to include(
        commercial_project_with_due_date[:dev_with_due_date][:booked])
      expect(subject).to include(
        internal_project[:dev_without_due_date][:booked])
      expect(subject).to include(
        internal_project[:dev_with_due_date][:booked])
      expect(subject).to include(
        unavailable[:dev_without_due_date][:booked])
      expect(subject).to include(
        unavailable[:dev_with_due_date][:booked])
    end

    it 'doesn\'t include others' do
      expect(subject.length).to eq(8)
    end
  end

  describe '#unavailable' do
    subject { described_class.new.unavailable }

    it 'includes unavailable devs with a due date with nothing scheduled' do
      expect(subject).to include(
        unavailable[:dev_with_due_date][:with_nothing_scheduled])
    end

    it 'includes unavailable devs without a due date' do
      expect(subject).to include(
        unavailable[:dev_without_due_date][:with_nothing_scheduled])
      expect(subject).to include(
        unavailable[:dev_without_due_date][:with_commercial_project_scheduled])
      expect(subject).to include(
        unavailable[:dev_without_due_date][:with_internal_project_scheduled])
    end

    it 'doesn\'t include others' do
      expect(subject.length).to eq(4)
    end
  end
end
