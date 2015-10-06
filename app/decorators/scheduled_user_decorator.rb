class ScheduledUserDecorator < UserDecorator
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

  def next_current_membership_ends_at
    latest_membership = object.current_memberships.joins(:project)
      .order('COALESCE(memberships.ends_at, projects.end_at)').first

    return nil if latest_membership.nil?

    if latest_membership.ends_at.present?
      latest_membership.ends_at
    else
      latest_membership.project.end_at
    end
  end

  def self.model_name
    ActiveModel::Name.new(User)
  end
end
