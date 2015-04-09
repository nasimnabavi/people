class Project < ActiveRecord::Base
  include Project::UserAvailability
  include InitialsHandler

  after_save :update_membership_fields
  after_save :check_potential
  before_save :set_color

  POSSIBLE_TYPES = %w(regular maintenance_support maintenance_development).freeze

  has_many :notes
  has_many :memberships, inverse_of: :project, dependent: :destroy

  accepts_nested_attributes_for :memberships

  validates :name, presence: true, uniqueness: { case_sensitive: false },
    format: { with: /\A[a-zA-Z0-9_\-]+\Z/ }
  validates :slug, allow_blank: true, allow_nil: true, uniqueness: true,
    format: { with: /\A[a-z\d]+\Z/ }
  validates :archived, inclusion: { in: [true, false] }
  validates :potential, inclusion: { in: [true, false] }
  validates :project_type, inclusion: { in: POSSIBLE_TYPES }

  scope :active, -> { where(archived: false) }
  scope :nonpotential, -> { active.where(potential: false) }
  scope :potential, -> { active.where(potential: true) }

  def to_s
    name
  end

  def api_slug
    slug.blank? ? name.try(:delete, '^[a-zA-Z0-9]*$').try(:downcase) : slug
  end

  def pm
    pm_membership = memberships.with_role(Role.pm).select(&:active?).first
    pm_membership.try(:user)
  end

  def self.search(search)
    Project.where(name: /#{search}/i)
  end

  private

  def update_membership_fields
    if potential_changed? || archived_changed?
      memberships.each do |membership|
        membership.update_attributes(project_potential: potential, project_archived: archived)
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
    self.colour ||= AvatarColor.new.as_rgb
  end
end
