class AvailableUserDecorator < UserDecorator
  include ActionView::Helpers::DateHelper
  attr_accessor :category

  def initialize(object, options = { context: {} })
    @category = options[:context][:category]
    super
  end

  def seconds_of_longest_current_membership
    return 0 if longest_current_membership.nil?
    (Time.now - longest_current_membership.starts_at.to_time).to_i
  end

  def self.model_name
    ActiveModel::Name.new(User)
  end
end
