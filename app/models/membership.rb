class Membership < ActiveRecord::Base
  include Membership::HipchatNotifications

  belongs_to :user, touch: true
  belongs_to :project, inverse_of: :memberships
  belongs_to :role

  validates :user, presence: true
  validates :project, presence: true
  validates :role, presence: true
  validates :starts_at, presence: true
  validates :billable, inclusion: { in: [true, false] }

  validate :validate_starts_at_ends_at
  validate :validate_duplicate_project

  after_create :notify_create_on_slack
  after_save :check_fields
  after_update :notify_update_on_slack

  scope :active, -> { where(project_potential: false, project_archived: false, booked: false) }
  scope :not_archived, -> { where(project_archived: false) }
  scope :potential, -> { where(project_potential: true) }
  scope :with_role, ->(role) { where(role: role) }
  scope :with_user, ->(user) { where(user: user) }
  scope :unfinished, -> { where('COALESCE(memberships.ends_at, :now) >= :now', now: Time.current) }
  scope :started, -> { where('memberships.starts_at <= NOW()') }
  scope :not_started, -> { where('memberships.starts_at > NOW()') }
  scope :billable, -> { where(billable: true) }
  scope :without_bookings, -> { where(booked: false) }
  scope :only_active, -> { active.order(starts_at: :desc).limit(3) }
  scope :not_internal, -> { where(project_internal: false) }

  def self.next_memberships
    not_started = arel_table[:starts_at].gt(Time.current)
    not_potential = arel_table[:project_potential].eq(false)
    not_booked = arel_table[:booked].eq(false)

    unfinished.where(not_started.and(not_potential).and(not_booked))
  end

  def self.qualifying
    has_end_date = arel_table[:ends_at].not_eq(nil)
    is_billable = arel_table[:billable].eq(true)
    no_end_date = arel_table[:ends_at].eq(nil)

    where(has_end_date.or(is_billable.and(no_end_date)))
  end

  def started?
    starts_at <= Date.today
  end

  def terminated?
    ends_at.try('<', Time.current) || false
  end

  def active?
    started? && !terminated?
  end

  def end_now!
    update(ends_at: Date.today)
  end

  def duration_in_months
    ((Time.current - starts_at.to_time) / UserDecorator::DAYS_IN_MONTH).round
  end

  private

  def check_fields
    if project_state_changed?
      update_columns(project_potential: project.potential, project_archived: project.archived,
        project_internal: project.internal
      )
    end
  end

  def project_state_changed?
    project_potential != project.potential || project_archived != project.archived || project_internal != project.internal
  end

  def validate_starts_at_ends_at
    if starts_at.present? && ends_at.present? && starts_at > ends_at
      errors.add(:ends_at, "can't be before starts_at date")
    end
  end

  def validate_duplicate_project
    MembershipCollision.new(self).call
  end

  def notify_create_on_slack
    notification = "*#{user.first_name} #{user.last_name}* has been added to *#{project.name}* since _#{starts_at.to_s(:ymd)}_"
    notification += ends_at.present? ? " to _#{ends_at.to_s(:ymd)}_." : '.'

    SlackNotifier.new.ping(notification)
  end

  def notify_update_on_slack
    return unless starts_at_changed? || ends_at_changed?

    notification = "Time span for *#{user.last_name} #{user.first_name}* in *#{project.name}* has been changed."
    notification += "\n#{field_change_msg(:starts_at)}" if starts_at_changed?
    notification += "\n#{field_change_msg(:ends_at)}" if ends_at_changed?

    SlackNotifier.new.ping(notification)
  end

  def field_change_msg(field)
    from, to = send("#{field.to_s}_change")

    msg = "#{field.to_s.humanize} changed from "
    msg += from.nil? ? '_not specified_ to ' : "_#{from.to_s(:ymd)}_ to "
    to.nil? ? msg + '_not specified_.' : msg + "_#{to.to_s(:ymd)}_."
  end
end
