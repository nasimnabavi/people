class Settings < ActiveRecord::Base
  validate :notifications_email, format: { with: Devise.email_regexp }

  class << self
    delegate :update_attributes,
             :notifications_email, to: :instance

    def instance
      first_or_create
    end
  end
end
