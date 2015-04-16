class AvailableUsersRepository
  def all
    User
      .includes(
        :roles,
        :abilities,
        :projects,
        current_memberships: [:project],
        potential_memberships: [:project],
        next_memberships: [:project],
        booked_memberships: [:project],
        last_membership: [:project],
        positions: [:role],
        primary_role: [:users])
      .where(available: true, archived: false, primary_role: technical_roles_ids)
  end

  private

  def technical_roles_ids
    @technical_roles_ids ||= Role.where(technical: true).pluck(:id)
  end
end
