class Position < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :role

  validates :user, presence: true
  validates :role, presence: true, uniqueness: { scope: :user_id }
  validates :starts_at, presence: true
  validates_with ::Position::ChronologyValidator
  validates_with ::Position::RoleValidator

  #default_scope -> { order(starts_at: :asc) }

  scope :primary, -> { where(primary: true) }

  after_create :notify_slack_on_create
  after_update :notify_slack_on_update

  def <=>(other)
    [user.last_name, user.first_name, starts_at] <=> [other.user.last_name,
                                                      other.user.first_name, other.starts_at]
  end

  private

  def notify_slack_on_create
    notification = "*#{user.last_name} #{user.first_name}* has been assigned a new role"
    notification += " (#{role.name}) since _#{starts_at.to_s(:ymd)}_."
    notification += "\nIt has also been marked as a *primary role*." if primary?

    SlackNotifier.new.ping(notification)
  end

  def notify_slack_on_update
    return unless primary_changed? || role_id_changed?
    notification = 'Role'
    notification += primary_toggled_notification if primary_changed?
    notification += role_changed_notification if role_id_changed?

    SlackNotifier.new.ping(notification)
  end

  def primary_toggled_notification
    notification = " _#{role.name}_ has been"
    notification += primary? ? " marked" : " unchecked"
    notification + " as the *primary role* for *#{user.last_name} #{user.first_name}*."
  end

  def role_changed_notification
    previous_role = Role.select(:name).find(changes[:role_id].first)
    notification = " _#{role.name}_ has been"
    notification += " also" if primary_changed?
    notification += " changed from _#{previous_role.name}_"
    notification + (primary_changed? ? '.' : "for *#{user.last_name} #{user.first_name}*.")
  end
end
