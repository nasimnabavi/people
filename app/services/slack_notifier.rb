class SlackNotifier
  attr_reader :options

  def initialize(options = {})
    @options = options.reverse_merge(default_options)
  end

  def ping(notification)
    return unless (webhook_url = AppConfig.slack.webhook_url).present?
    Slack::Notifier.new(webhook_url, options).ping(notification)
  end

  private

  def default_options
    { username: AppConfig.slack.username }
  end
end
