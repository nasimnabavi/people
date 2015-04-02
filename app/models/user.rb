class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :trackable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2, :github]

  mount_uploader :gravatar, GravatarUploader

  has_many :memberships, ->{ order(:ends_at) }, dependent: :destroy
  has_many :notes
  has_many :positions
  has_many :roles, through: :positions
  belongs_to :admin_role
  belongs_to :contract_type
  belongs_to :location
  belongs_to :team, inverse_of: :users
  belongs_to :leader_team, class_name: 'Team', inverse_of: :leader
  belongs_to :primary_role, class_name: 'Role'
  has_and_belongs_to_many :abilities

  # ugly optimization hack
  has_many :current_memberships, -> { active.unfinished.started }, class: Membership
  has_many :potential_memberships, -> { potential.unfinished }, class: Membership
  has_many :next_memberships, -> { next_memberships }, class: Membership
  has_many :booked_memberships, -> {
    where(booked: true)
      .where("ends_at = ? OR ends_at > ?", nil, Time.now)
  }, class: Membership
  has_one :last_membership, -> { active.unfinished.started.order('ends_at DESC NULLS FIRST') }, class: Membership

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :employment, inclusion: { in: 0..200, message: 'must be between 0-200' }
  validates :phone, phone_number: true, length: { maximum: 16 }, allow_blank: true
  validates :archived, inclusion: { in: [true, false] }

  scope :by_name, -> {
    includes(:primary_role, :memberships, positions: [:role])
      .order(:first_name, :last_name)
  }
  scope :by_last_name, -> { order(:last_name, :first_name) }
  scope :available, -> { where(available: true) }
  scope :active, -> { where(archived: false) }
  scope :technical, -> { where(primary_role: Role.technical.pluck(:id)) }
  scope :technical_active, -> { where(archived: false, available: true) }
  scope :roles, -> (roles) { where(primary_role: roles) }
  scope :contract_users, ->(contract_type) {
    ContractType.where(name: contract_type).first.try(:users)
  }
  scope :without_team, -> { where(team: nil) }

  before_save :end_memberships
  before_update :save_team_join_time

  def self.cache_key
    maximum(:updated_at)
  end

  def github_connected?
    gh_nick.present? || without_gh == true
  end

  def admin?
    admin_role.present?
  end

  def has_current_projects?
    current_memberships.present?
  end

  def has_next_projects?
    next_memberships.present?
  end

  def has_potential_projects?
    potential_memberships.present?
  end

  def end_memberships
    memberships.each(&:end_now!) if archived_change && archived_change.last
  end

  def user_membership_repository
    @user_membership_repository ||= UserMembershipRepository.new(self)
  end

  private

  def save_team_join_time
    if team_id_changed?
      team_join_val = team_id.present? ? DateTime.now : nil
      assign_attributes(team_join_time: team_join_val)
    end
  end
end
