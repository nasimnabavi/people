require 'spec_helper'

describe Membership do
  subject { build(:membership, starts_at: Time.now) }

  let(:slack_config) { OpenStruct.new(webhook_url: 'webhook_url', username: 'PeopleApp') }
  let(:notifier) { Slack::Notifier.new(slack_config.webhook_url, username: slack_config.username) }
  let(:response_ok) { Net::HTTPOK.new('1.1', 200, 'OK') }

  before do
    allow(AppConfig).to receive(:slack).and_return(slack_config)
    allow(Slack::Notifier).to receive(:new).and_return(notifier)
    allow(notifier).to receive(:ping).and_return(response_ok)
  end

  it { should belong_to :user }
  it { should belong_to :project }
  it { should belong_to :role }
  it { should be_valid }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:project) }
  it { should validate_presence_of(:role) }

  describe '#validate_starts_at_ends_at' do
    it "adds an error if 'ends_at' is before 'starts_at'" do
      subject.ends_at = subject.starts_at - 2.days
      subject.send :validate_starts_at_ends_at
      expect(subject.errors[:ends_at]).to include("can't be before starts_at date")
    end
  end

  describe '#validate_duplicate_project' do
    let(:user) { create(:user) }
    let(:project) { create(:project) }
    let(:membership) { build(:membership, user: user, project: project) }

    before do
      [
        [Time.new(2013, 1, 1), Time.new(2013, 6, 1)],
        [Time.new(2013, 6, 2), Time.new(2013, 8, 30)],
        [Time.new(2013, 10, 1), nil]
      ].each { |time_range| create(:membership, user: user, project: project, starts_at: time_range[0], ends_at: time_range[1]) }
    end

    context "valid" do
      [
        [Time.new(2012, 1, 1), Time.new(2012, 6, 1)],
        [Time.new(2013, 9, 1), Time.new(2013, 9, 30)]
      ].each do |time_range|
        it "start #{time_range[0]} ends #{time_range[1]}" do
          membership.starts_at, membership.ends_at = time_range
          expect(membership).to be_valid
        end
      end
    end

    context "invalid" do
      [
        [Time.new(2012, 1, 1), nil],
        [Time.new(2013, 11, 1), nil],
        [Time.new(2013, 1, 1), Time.new(2013, 5, 1)]
      ].each do |time_range|
        it "start #{time_range[0]} ends #{time_range[1]}" do
          membership.starts_at, membership.ends_at = time_range
          expect(membership).to_not be_valid
        end
      end
    end
  end

  describe "active?" do

    subject { membership.active? }

    context "when membership is not yet started" do
      let(:membership) { build(:membership, starts_at: 2.days.from_now, ends_at: 5.months.from_now) }
      it { should be false }
    end

    context "when membership is strated but not ended" do
      let(:membership) { build(:membership, starts_at: 1.month.ago, ends_at: 2.months.from_now) }
      it { should be true }
    end

    context "when membership is started and has no end" do
      let(:membership) { build(:membership, starts_at: 1.month.ago, ends_at: nil) }
      it { should be true }
    end

    context "when membership is started and ended" do
      let(:membership) { build(:membership, starts_at: 5.months.ago, ends_at: 1.week.ago) }
      it { should be false }
    end
  end

  describe "#end_now!" do
    let(:past_membership) { build(:membership, starts_at: 2.months.ago, ends_at: 1.month.ago) }
    let(:current_membership) { build(:membership, starts_at: 1.months.ago, ends_at: 1.month.from_now) }
    let(:future_membership) { build(:membership, starts_at: 2.months.from_now, ends_at: 3.months.from_now) }

    it "does not influence past memberships" do
      expect{past_membership.end_now!}.to_not change{past_membership.ends_at}
    end

    it "influences current memberships" do
      expect{current_membership.end_now!}.to change{current_membership.ends_at}
    end

    it "does not influence future memberships" do
      expect{future_membership.end_now!}.to_not change{future_membership.ends_at}
    end
  end

  describe "#duration_in_months" do
    let(:membership_1_month) { build(:membership, starts_at: 1.month.ago) }
    let(:membership_6_months) { build(:membership, starts_at: 6.months.ago) }

    it "returns an integer that presens number of months from starts_at" do
      expect(membership_1_month.duration_in_months).to eql(1)
      expect(membership_6_months.duration_in_months).to eql(6)
    end
  end

  context "creating model" do
    let(:membership) { build(:membership, starts_at: 5.months.ago, ends_at: nil) }

    it 'triggers notify_slack_on_create after create' do
      expect(membership).to receive(:notify_slack_on_create).once
      membership.save
    end
  end

  context "updating model" do
    let(:membership) { create(:membership, starts_at: 5.months.ago, ends_at: nil) }

    it 'triggers notify_slack_on_update after update' do
      expect(membership).to receive(:notify_slack_on_update).once
      membership.update(ends_at: Date.current + 2.days)
    end
  end

  context "notifies on slack if created" do
    describe "#notify_slack_on_create" do
      let(:membership) { build(:membership, starts_at: 5.months.ago, ends_at: nil) }
      let(:membership_with_ends_at) { build(:membership, starts_at: 5.months.ago, ends_at: 1.day.ago) }

      it 'notifies with proper message if only starts_at set' do
        expected_notification = "*#{membership.user.last_name} #{membership.user.first_name}*"
        expected_notification += " has been added to *#{membership.project.name}* since _#{membership.starts_at}_."

        expect(notifier).to receive(:ping).with(expected_notification).once
        membership.save
      end

      it 'notifies with proper message of starts_at and ends_at set' do
        expected_notification = "*#{membership_with_ends_at.user.last_name} #{membership_with_ends_at.user.first_name}*"
        expected_notification += " has been added to *#{membership_with_ends_at.project.name}* since"
        expected_notification += " _#{membership_with_ends_at.starts_at}_ to _#{membership_with_ends_at.ends_at}_."

        expect(notifier).to receive(:ping).with(expected_notification).once
        membership_with_ends_at.save
      end
    end
  end

  context "notifies on slack if dates updated" do
    describe "#notify_slack_on_update" do
      let!(:membership) { create(:membership, starts_at: 5.months.ago, ends_at: nil) }

      it 'notifies with proper message if starts_at and ends_at changed' do
        new_starts_at = membership.starts_at + 1.day
        new_ends_at = Date.current + 2.days
        expected_notification = "Time span for *#{membership.user.last_name} #{membership.user.first_name}*"
        expected_notification += " in *#{membership.project.name}* has been changed."
        expected_notification += "\nStarts at changed from _#{membership.starts_at}_ to _#{new_starts_at}_."
        expected_notification += "\nEnds at changed from _not specified_ to _#{new_ends_at}_."

        expect(notifier).to receive(:ping).with(expected_notification).once
        membership.update(starts_at: new_starts_at, ends_at: new_ends_at)
      end

      it 'notifies with proper message if only starts_at changed' do
        new_starts_at = membership.starts_at + 1.day
        expected_notification = "Time span for *#{membership.user.last_name} #{membership.user.first_name}*"
        expected_notification += " in *#{membership.project.name}* has been changed."
        expected_notification += "\nStarts at changed from _#{membership.starts_at}_ to _#{new_starts_at}_."

        expect(notifier).to receive(:ping).with(expected_notification).once
        membership.update(starts_at: new_starts_at)
      end

      it 'notifies with proper message if only ends_at changed' do
        new_ends_at = Date.current + 2.days
        expected_notification = "Time span for *#{membership.user.last_name} #{membership.user.first_name}*"
        expected_notification += " in *#{membership.project.name}* has been changed."
        expected_notification += "\nEnds at changed from _not specified_ to _#{new_ends_at}_."

        expect(notifier).to receive(:ping).with(expected_notification).once
        membership.update(ends_at: new_ends_at)
      end

      it 'will not send a notification to slack if starts_at or ends_at are not updated' do
        expect(notifier).to receive(:ping).exactly(0).times
        membership.update(role_id: 1)
      end
    end
  end
end
