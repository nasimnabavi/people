class StagingMailInterceptor
  ALLOWED_EMAILS = %w(
    dorota.nieweglowska@netguru.co
    mateusz.palyz@netguru.pl).freeze

  def self.delivering_email(message)
    message.to = extract_allowed_recepients(message)
    message.perform_deliveries = false if message.to.empty?
  end

  def self.extract_allowed_recepients(message)
    message.to.select { |address| ALLOWED_EMAILS.include?(address) }
  end
end
