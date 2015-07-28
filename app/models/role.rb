class Role < ActiveRecord::Base
  has_many :memberships
  has_many :positions
  has_many :users, through: :positions

  validates :priority, presence: true
  validates :name, presence: true, uniqueness: true
  validates :billable, inclusion: { in: [true, false] }
  validates :technical, inclusion: { in: [true, false] }

  default_scope -> { order(priority: :asc) }
  scope :billable, -> { where(billable: true) }
  scope :non_billable, -> { where(billable: false) }
  scope :technical, -> { where(technical: true) }
  scope :junior_or_intern, lambda {
    where(name: ['intern', 'junior', 'junior android', 'junior iOS', 'junior frontend'])
  }

  def to_s
    name
  end

  def self.pm
    where(name: 'pm').first_or_create
  end

  def self.by_name
    all.sort_by { |r| r.name.downcase }
  end
end
