class SlackNotifier
  attr_reader :options

  def initialize(options = {})
    @options = options.reverse_merge(default_options)
  end

  def ping(notification)
    Slack::Notifier.new(AppConfig.slack.webhook_url, options).ping(notification)
  end

  private

  def default_options
    { username: AppConfig.slack.username }
  end
end
