class Position < ActiveRecord::Base
  belongs_to :user
  belongs_to :role

  validates :user, presence: true
  validates :role, presence: true, uniqueness: { scope: :user_id }
  validates :starts_at, presence: true
  validates_with ::Position::ChronologyValidator
  validates_with ::Position::RoleValidator

  default_scope -> { order(starts_at: :asc) }

  def <=>(other)
    [user.last_name, user.first_name, starts_at] <=> [other.user.last_name,
                                                      other.user.first_name, other.starts_at]
  end
end
