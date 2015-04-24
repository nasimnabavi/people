class UserSearch < Searchlight::Search

  search_on User

  searches :id, :email, :id_or_email, :pm, :qa, :developer, :primary

  def search_id
    search.where(id: id)
  end

  def search_email
    search.where(email: email)
  end

  def search_id_or_email
    by_id = search.where(id: id_or_email['id'])
    by_id.count > 0 ? by_id : search.where(email: id_or_email['email'])
  end

  def search_pm
    search_role_by_names(%w(pm junior_pm))
  end

  def search_qa
    search_role_by_names(%w(qa junior_qa))
  end

  def search_developer
    search.includes(positions: :role).where('roles.technical' => true)
  end

  def search_primary
    search.where.not(primary_role: nil)
  end

  private

  def search_role_by_names(names)
    search.includes(positions: :role).where('roles.name' => names)
  end
end
