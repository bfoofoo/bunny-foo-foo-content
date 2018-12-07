class SlackNotifier
  include Singleton

  def initialize
    @notifier = Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL']) do
      defaults channel: "#adsense-pulse", username: "Slack-Notifier", icon_url: 'https://metclouds.com/wp-content/uploads/2018/01/rordev.png'
    end
  end

  def message(msg)
    @notifier.ping(msg)
  end

  def post(attachment)
    @notifier.post(attachments: [attachment])
  end
end