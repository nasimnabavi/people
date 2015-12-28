class RolesRepository
  def all
    @all ||= Role.includes(:users).all
  end

  def all_technical
    all.technical
  end

  def all_by_name
    all.by_name
  end
end
