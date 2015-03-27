class UserRolesRepository
  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def all
    # Optimize for HMT relation once PostgreSQL is ready
    @all ||= user.positions.includes(:role).map(&:role)
  end
end
