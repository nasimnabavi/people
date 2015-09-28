require 'spec_helper'

describe SlackNotifier do
  let(:notification) { 'Something really cool to notify.' }
  let(:response_ok) { Net::HTTPOK.new('1.1', 200, 'OK') }
  let(:notifier) { Slack::Notifier.new(AppConfig.slack.webhook_url, username: 'test_user') }

  describe '#new' do
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
      expect(notifier).to receive(:ping).with(notification).and_return(response_ok)
      described_class.new.ping(notification)
    end
  end
end
