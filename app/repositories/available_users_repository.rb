class AvailableUsersRepository
  def all
    User.includes(:roles, :primary_role, :abilities)
      .includes(positions: [:role], memberships: [:project])
      .includes(:current_memberships, :potential_memberships, :next_memberships, :booked_memberships, :last_membership)
      .where(available: true)
      .where(archived: false)
      .where(primary_role: technical_roles)
  end

  private

  def technical_roles
    Role.where(technical: true).pluck(:id)
  end
end
