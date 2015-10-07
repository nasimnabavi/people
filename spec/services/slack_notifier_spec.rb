require 'spec_helper'

describe SlackNotifier do
  let(:slack_config) { OpenStruct.new(webhook_url: 'webhook_url', username: 'PeopleApp') }
  let(:notification) { Object.new }
  let(:response_ok) { Net::HTTPOK.new('1.1', 200, 'OK') }
  let(:notifier) { Slack::Notifier.new(slack_config.webhook_url, username: 'test_user') }

  describe '#new' do
    before do
      allow(AppConfig).to receive(:slack).and_return(slack_config)
    end

    it 'initializes with correct and default options' do
      expect(described_class.new.options).to eql(username: AppConfig.slack.username)
    end

    it 'overwrites default options' do
      expect(described_class.new(username: 'test_user').options).to eql(username: 'test_user')
    end
  end

  describe '#ping' do
    before do
      allow(Slack::Notifier).to receive(:new).and_return(notifier)
    end

    it 'send a message via Slack::Notifier gem' do
      allow(AppConfig).to receive(:slack).and_return(slack_config)
      allow(notification).to receive(:message).and_return('Something cool to notify.')
      expect(notifier).to receive(:ping).with('Something cool to notify.').and_return(response_ok)
      described_class.new.ping(notification)
    end

    it 'will not call a ping method from Slack::Notifier if webhook_url is not present' do
      expect(notifier).to receive(:ping).exactly(0).times
      expect(described_class.new.ping(notification)).to be_nil
    end

    it "won't call a ping method from Slack::Notifier if message from notification object is nil" do
      allow(AppConfig).to receive(:slack).and_return(slack_config)
      allow(notification).to receive(:message).and_return(nil)
      expect(notifier).to receive(:ping).exactly(0).times
      expect(described_class.new.ping(notification)).to be_nil
    end
  end
end
