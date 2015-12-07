class Project < ActiveRecord::Base
  include InitialsHandler

  before_save :set_color, :check_maintenance
  after_save :update_membership_fields, :check_potential
  after_update :notify_if_dates_changed

  POSSIBLE_TYPES = %w(regular maintenance).freeze
  EXCLUDED_PROJECTS = %w(unavailable).freeze

  has_many :notes
  has_many :memberships, inverse_of: :project, dependent: :destroy
  has_many :users, through: :memberships

  accepts_nested_attributes_for :memberships

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :archived, inclusion: { in: [true, false] }
  validates :potential, inclusion: { in: [true, false] }
  validates :project_type, inclusion: { in: POSSIBLE_TYPES }
  validates :maintenance_since, presence: true, if: 'maintenance?'

  scope :active, -> { where(archived: false) }
  scope :nonpotential, -> { active.where(potential: false) }
  scope :potential, -> { active.where(potential: true) }
  scope :unfinished, -> { where('end_at IS NULL OR end_at > ?', Time.current) }
  scope :started, -> { where('kickoff IS NULL OR kickoff <= ?', Time.current) }
  scope :unavailable, -> { where('lower(name) = ?', 'unavailable') }
  scope :commercial, -> { where(internal: false) }
  scope :internal, -> { where(internal: true) }
  scope :starts_after, ->(time) { where('starts_at >= ?', time) }
  scope :starts_before, ->(time) { where('starts_at <= ?', time) }
  scope :ends_after, ->(time) { where('end_at IS NULL OR end_at >= ?', time) }
  scope :ends_before, ->(time) { where('end_at <= ?', time) }
  scope :without_excluded, -> { where.not('name IN (?)', EXCLUDED_PROJECTS) }
  scope :no_maintenance_before, lambda { |time|
    where('maintenance_since IS NULL OR maintenance_since > ?', time)
  }
  scope :maintenance_before, ->(time) { where('maintenance_since <= ?', time) }
  scope :commercial_between, lambda { |start_date, end_date|
    commercial.starts_before(end_date).ends_after(start_date)
      .no_maintenance_before(end_date).order('LOWER(name)')
  }
  scope :internal_between, lambda { |start_date, end_date|
    internal.starts_before(end_date).ends_after(start_date).without_excluded.order('LOWER(name)')
  }
  scope :maintenance_between, lambda { |start_date, end_date|
    commercial.starts_before(end_date).ends_after(start_date)
      .maintenance_before(end_date).order('LOWER(name)')
  }
  scope :ends_between, lambda { |start_date, end_date|
    ends_after(start_date).ends_before(end_date).order('LOWER(name)')
  }
  scope :beginning_between, lambda { |start_date, end_date|
    potential.starts_after(start_date).starts_before(end_date).order('LOWER(name)')
  }
  scope :maintenance, -> { where(project_type: 'maintenance') }
  scope :not_maintenance, -> { where.not(project_type: 'maintenance') }

  def to_s
    name
  end

  def api_slug
    name.try(:delete, '^[a-zA-Z0-9]*$').try(:downcase)
  end

  def pm
    pm_membership = memberships.with_role(Role.pm).select(&:active?).first
    pm_membership.try(:user)
  end

  def self.search(search)
    Project.where(name: /#{search}/i)
  end

  def maintenance?
    project_type == 'maintenance'
  end

  private

  def update_membership_fields
    if potential_changed? || archived_changed? || internal_changed?
      memberships.each do |membership|
        membership.update_attributes(project_potential: potential, project_archived: archived,
          project_internal: internal)
      end
    end
  end

  def check_potential
    if potential_change == [true, false]
      set_proper_membership_dates
    end
  end

  def set_proper_membership_dates
    memberships.each do |membership|
      if membership.stays
        membership.update(starts_at: Date.today)
      else
        membership.destroy
      end
    end
  end

  def set_color
    self.color ||= AvatarColor.new.as_rgb
  end

  def check_maintenance
    self.maintenance_since = nil unless maintenance? && maintenance_since
  end

  def notify_if_dates_changed
    SlackNotifier.new.ping(Notification::Project::DatesChanged.new(self))
  end
end
