class PositionCountRepository

  METHODS = {
    senior_android_devs: 'senior_android',
    senior_ios_devs: 'senior iOS',
    senior_ror_devs: 'senior RoR',
    senior_frontend_devs: 'senior frontend',
    senior_designers: 'senior designer/UX',
    senior_project_managers: 'senior PM',
    senior_quality_assurance: 'senior QA',
    android_devs: 'android',
    ios_devs: 'iOS',
    ror_devs: 'developer RoR',
    frontend_devs: 'frontend',
    designers:'designer/UX',
    project_managers: 'PM',
    quality_assurance: 'QA',
    quality_assurance: 'QA',
    interns: 'intern',
    junior_ror: 'junior RoR',
    junior_ios: 'junior iOS',
    junior_android: 'junior android',
    junior_frontend: 'junior frontend',
    junior_project_managers: 'junior PM',
    junior_quality_assurance: 'junior qa',
    support_developers: 'support'
  }

  # def senior_android_devs, def senior_ios_devs, def senior_ror_devs, def senior_frontend_devs,
  # def senior_designers, def senior_project_managers, def senior_quality_assurance,
  # def android_devs, def ios_devs, def ror_devs, def frontend_devs, def designers,
  # def project_managers, def quality_assurance, def quality_assurance, def interns,
  # def junior_ror, def junior_ios, def junior_android, def junior_frontend,
  # def junior_project_managers, def junior_quality_assurance, def support_developers
  METHODS.each do |method_name, role_name|
    define_method method_name do
      count_for_position(role_name)
    end
  end

  def ror_group
    {
      interns_size: interns,
      juniors_size: junior_ror,
      regulars_size: ror_devs,
      seniors_size: senior_ror_devs
    }
  end

  def ios_group
    {
      interns_size: 0,
      juniors_size: junior_ios,
      regulars_size: ios_devs,
      seniors_size: senior_ios_devs
    }
  end

  def android_group
    {
      interns_size: 0,
      juniors_size: junior_android,
      regulars_size: android_devs,
      seniors_size: senior_android_devs
    }
  end

  def frontend_group
    {
      interns_size: 0,
      juniors_size: junior_frontend,
      regulars_size: frontend_devs,
      seniors_size: senior_frontend_devs
    }
  end

  def designers_group
    {
      interns_size: 0,
      juniors_size: 0,
      regulars_size: designers,
      seniors_size: senior_designers
    }
  end

  def pms_group
    {
      interns_size: 0,
      juniors_size: junior_project_managers,
      regulars_size: project_managers,
      seniors_size: senior_project_managers
    }
  end

  def qas_group
    {
      interns_size: 0,
      juniors_size: junior_quality_assurance,
      regulars_size: quality_assurance,
      seniors_size: senior_quality_assurance
    }
  end

  private

  def roles_ids
    @roles_ids ||= Role.all.pluck(:name, :id).to_h
  end

  def positions_counts
    @positions_counts ||= Position.where(primary: true).group(:role_id).size
  end

  def count_for_position(position_name)
    positions_counts[roles_ids[position_name]] || 0
  end
end
