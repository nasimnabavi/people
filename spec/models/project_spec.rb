require 'spec_helper'

describe Project do
  subject { build(:project) }

  it { should have_many :memberships }
  it { should be_valid }
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of(:name).case_insensitive }

  describe "pm" do
    let(:actual_membership) { build(:membership, starts_at: 1.week.ago, ends_at: 1.week.from_now) }
    let(:old_membership) { build(:membership, starts_at: 2.weeks.ago, ends_at: 1.week.ago) }
    let(:future_membership) { build(:membership, starts_at: 1.week.from_now, ends_at: 2.weeks.from_now) }

    before do
      allow(Membership).to receive(:with_role).and_return([actual_membership, old_membership, future_membership])
    end

    its(:pm) { should eq(actual_membership.user) }
    its(:pm) { should_not eq(old_membership.user) }
    its(:pm) { should_not eq(future_membership.user) }
  end

  describe "#set_initials" do
    let(:project_camel_case) { create(:project, name: 'BolshoeSpasibo') }
    let(:project) { create(:project, name: 'Blyuz') }
    let(:project_multiword) { create(:project, name: 'BolshoeSpasiboHarosho') }

    context "camel case name" do
      it "sets initials of a project" do
        expect(project_camel_case.initials).to eq 'BS'
      end
    end

    context "1 word name" do
      it "sets initials of a project" do
        expect(project.initials).to eq 'B'
      end
    end

    context "multiword name with spaces" do
      it "sets initials of a project" do
        expect(project_multiword.initials).to eq 'BS'
      end
    end
  end

  describe "#set_colour" do
    let(:project) { create(:project) }
    it "sets random colour in hex format" do
      expect(project.colour).to match(/#[a-f0-9]{6}/)
    end
  end

  context "updating model" do
    let(:project) { create(:project) }

    it 'trigger notify_if_dates_changed after update' do
      expect(project).to receive(:notify_if_dates_changed).once
      project.update(kickoff: project.end_at + 1.day)
    end
  end

  context "notifies on slack if dates updated" do
    describe "#notify_if_dates_changed" do
      let(:notifier) { Slack::Notifier.new(AppConfig.slack.webhook_url, username: 'test_user') }
      let(:response_ok) { Net::HTTPOK.new('1.1', 200, 'OK') }
      let(:project) { create(:project) }

      before do
        allow(Slack::Notifier).to receive(:new).and_return(notifier)
        allow(notifier).to receive(:ping).and_return(response_ok)
      end

      it 'notifies with proper message if kickoff changed' do
        new_date = project.end_at + 1.day
        expected_notification = "Dates in project *#{project.name}* has been updated."
        expected_notification += "\n*Kickoff* changed to _#{new_date.to_s(:ymd)}_."

        expect(notifier).to receive(:ping).with(expected_notification).once
        project.update(kickoff: new_date)
      end

      it 'notifies with proper message if starts_at changed' do
        new_date = project.end_at + 1.day
        expected_notification = "Dates in project *#{project.name}* has been updated."
        expected_notification += "\n*Starts at* changed to _#{new_date.to_s(:ymd)}_."

        expect(notifier).to receive(:ping).with(expected_notification).once
        project.update(starts_at: new_date)
      end

      it 'notifies with proper message if end_at changed' do
        new_date = project.end_at + 1.day
        expected_notification = "Dates in project *#{project.name}* has been updated."
        expected_notification += "\n*End at* changed to _#{new_date.to_s(:ymd)}_."

        expect(notifier).to receive(:ping).with(expected_notification).once
        project.update(end_at: new_date)
      end

      it 'notifies with proper message if all dates changed' do
        new_date = project.end_at + 1.day
        expected_notification = "Dates in project *#{project.name}* has been updated."
        expected_notification += "\n*Kickoff* changed to _#{new_date.to_s(:ymd)}_."
        expected_notification += "\n*Starts at* changed to _#{new_date.to_s(:ymd)}_."
        expected_notification += "\n*End at* changed to _#{new_date.to_s(:ymd)}_."

        expect(notifier).to receive(:ping).with(expected_notification).once
        project.update(kickoff: new_date, starts_at: new_date, end_at: new_date)
      end

      it 'notifies with proper message if some date is changed to nil' do
        new_date = project.end_at + 1.day
        expected_notification = "Dates in project *#{project.name}* has been updated."
        expected_notification += "\n*Kickoff* changed to _#{new_date.to_s(:ymd)}_."
        expected_notification += "\n*End at* cleared."

        expect(notifier).to receive(:ping).with(expected_notification).once
        project.update(kickoff: new_date, end_at: nil)
      end

      it 'does not notify if any of dates changed' do
        expect(notifier).to receive(:ping).exactly(0).times
        project.update(name: 'aaaaa')
      end
    end
  end
end
