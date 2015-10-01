require 'spec_helper'

describe Position do
  subject { build(:position, starts_at: Time.now) }

  it { should belong_to :role }
  it { should belong_to :user }
  it { should be_valid }

  describe 'role validation' do
    let(:juniorRole) { create(:role, name: 'junior', technical: true, priority: 3) }
    let!(:seniorRole) { create(:role, name: 'senior', technical: true, priority: 1) }
    let!(:user) { create(:user, primary_role: juniorRole) }

    it "doesn't allow to set a given role when user has this role already" do
      create(:position, user: user, role: juniorRole, starts_at: Time.now)
      pos = build(:position, user: user, role: juniorRole)
      expect(pos).to_not be_valid
    end

    it 'allows to set any role when there is no position assigned' do
      pos = create(:position, user: user)
      pos.role = juniorRole
      expect(pos).to be_valid
      pos.role = seniorRole
      expect(pos).to be_valid
    end
  end

  describe '#validate chronology' do
    let(:juniorRole) { create(:role, name: 'junior', technical: true, priority: 3) }
    let!(:seniorRole) { create(:role, name: 'senior', technical: true, priority: 1) }
    let!(:user) { create(:user, primary_role: juniorRole) }
    let!(:juniorPos) do
      create(:position,
              user: user, role: juniorRole, starts_at: Date.new(2014, 5, 14))
    end

    it 'returns error when dates are wrong' do
      pos = build(:position, user: user, role: seniorRole,
                  starts_at: juniorPos.starts_at - 2.days)

      expect(pos).not_to be_valid
      expect(pos.errors).not_to be_blank
      expect(pos.errors).to include :starts_at
      expect(pos.errors[:starts_at]).to include I18n.t('positions.errors.chronology')
    end

    it 'returns error when no "Starts at" provided and some position exists' do
      senior_position = build(:position, user: user, role: seniorRole, starts_at: nil)
      expect(senior_position).to_not be_valid
      expect(senior_position.errors[:starts_at]).to include("can't be blank")
    end

    it 'will not return error when dates chronology is ok' do
      senior_pos = build(:position, user: user, role: seniorRole, starts_at: juniorPos.starts_at + 2.days)
      expect(senior_pos).to be_valid
      expect(senior_pos.errors).to be_blank
    end
  end

  context 'creating model' do
    it 'triggers notify_slack_on_create after create' do
      expect(subject).to receive(:notify_slack_on_create).once
      subject.save
    end
  end

  context 'updating model' do
    let(:position) { create(:position, starts_at: Time.now) }

    it 'triggers notify_slack_on_update after update' do
      expect(position).to receive(:notify_slack_on_update).once
      position.update(primary: !position.primary)
    end
  end

  describe '#notify_slack_on_create' do
    let(:slack_config) { OpenStruct.new(webhook_url: 'webhook_url', username: 'PeopleApp') }
    let(:notifier) { Slack::Notifier.new(slack_config.webhook_url, username: slack_config.username) }
    let(:response_ok) { Net::HTTPOK.new('1.1', 200, 'OK') }
    let(:position_primary) { build(:position, :primary, starts_at: Time.current) }

    before do
      allow(AppConfig).to receive(:slack).and_return(slack_config)
      allow(Slack::Notifier).to receive(:new).and_return(notifier)
      allow(notifier).to receive(:ping).and_return(response_ok)
    end

    it 'sends a notification with proper message if primary set to true' do
      expected_notification = "*#{position_primary.user.last_name} #{position_primary.user.first_name}*"
      expected_notification += " has been assigned a new role (#{position_primary.role.name})"
      expected_notification += " since _#{position_primary.starts_at.to_s(:ymd)}_."
      expected_notification += "\nIt has also been marked as a *primary role*."

      expect(notifier).to receive(:ping).with(expected_notification).once
      position_primary.save
    end

    it 'sends a notification with proper message if primary set to false' do
      expected_notification = "*#{subject.user.last_name} #{subject.user.first_name}*"
      expected_notification += " has been assigned a new role"
      expected_notification += " (#{subject.role.name}) since _#{subject.starts_at.to_s(:ymd)}_."

      expect(notifier).to receive(:ping).with(expected_notification).once
      subject.save
    end
  end

  describe '#notify_slack_on_update' do
    let(:slack_config) { OpenStruct.new(webhook_url: 'webhook_url', username: 'PeopleApp') }
    let(:notifier) { Slack::Notifier.new(slack_config.webhook_url, username: slack_config.username) }
    let(:response_ok) { Net::HTTPOK.new('1.1', 200, 'OK') }
    let(:position) { create(:position, starts_at: Time.current) }
    let(:position_primary) { create(:position, :primary, starts_at: Time.current) }
    let(:senior_role) { create(:role, name: 'senior', technical: true, priority: 1) }

    before do
      allow(position).to receive(:notify_slack_on_create)
      allow(position_primary).to receive(:notify_slack_on_create)
      allow(AppConfig).to receive(:slack).and_return(slack_config)
      allow(Slack::Notifier).to receive(:new).and_return(notifier)
    end

    it 'does not send a notification if neither primary nore role_id changed' do
      expect(notifier).to receive(:ping).exactly(0).times
      position.update(starts_at: position.starts_at + 1.day)
    end

    it 'sends notification with proper message if primary changed to true' do
      expected_notification = "Role _#{position.role.name}_ has been marked as the *primary role*"
      expected_notification += " for *#{position.user.last_name} #{position.user.first_name}*."

      expect(notifier).to receive(:ping).with(expected_notification).and_return(response_ok).once
      position.update(primary: true)
    end

    it 'sends notification with proper message if primary changed to false' do
      expected_notification = "Role _#{position_primary.role.name}_ has been unchecked as the"
      expected_notification += " *primary role* for *#{position_primary.user.last_name}"
      expected_notification += " #{position_primary.user.first_name}*."

      expect(notifier).to receive(:ping).with(expected_notification).and_return(response_ok).once
      position_primary.update(primary: false)
    end

    it 'sends notification with proper message if only role changed' do
      expected_notification = "Role _#{senior_role.name}_ has been"
      expected_notification += " changed from _#{position.role.name}_"
      expected_notification += "for *#{position.user.last_name} #{position.user.first_name}*."

      expect(notifier).to receive(:ping).with(expected_notification).and_return(response_ok).once
      position.update(role_id: senior_role.id)
    end

    it 'sends notification with proper message if role and primary flag changed' do
      expected_notification = "Role _#{senior_role.name}_ has been unchecked as the *primary role*"
      expected_notification += " for *#{position_primary.user.last_name}"
      expected_notification += " #{position_primary.user.first_name}*. _#{senior_role.name}_"
      expected_notification += " has been also changed from _#{position_primary.role.name}_."

      expect(notifier).to receive(:ping).with(expected_notification).and_return(response_ok).once
      position_primary.update(role_id: senior_role.id, primary: false)
    end
  end
end
