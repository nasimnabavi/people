class AvailableUsersRepository
  def all
    User
      .includes(:roles, :abilities, :current_memberships,
        :potential_memberships, :next_memberships, :booked_memberships,
        :last_membership, positions: [:role], memberships: [:project],
        primary_role: [:users])
      .where(available: true, archived: false, primary_role: technical_roles_ids)
  end

  private

  def technical_roles_ids
    @technical_roles_ids ||= Role.where(technical: true).pluck(:id)
  end
end
