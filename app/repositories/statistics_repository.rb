class StatisticsRepository
  include DatesManagement
  include ActiveModel::Serialization

  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
  end

  def commercial_projects
    Project.commercial_between(start_date, end_date)
  end

  def internal_projects
    Project.internal_between(start_date, end_date)
  end

  def maintenance_projects
    Project.maintenance_between(start_date, end_date)
  end

  def projects_ending_between
    Project.ends_between(start_date, end_date)
  end

  def beginning_soon_projects
    Project.beginning_between(today, thirty_days_from_today)
  end

  def senior_android_devs
    User.billable_roles_between(['senior android'], start_date, end_date)
  end

  def senior_ios_devs
    User.billable_roles_between(['senior iOS'], start_date, end_date)
  end

  def senior_ror_devs
    User.billable_roles_between(['senior RoR'], start_date, end_date)
  end

  def senior_frontend_devs
    User.billable_roles_between(['senior frontend'], start_date, end_date)
  end

  def senior_designers
    User.billable_roles_between(['senior designer/UX'], start_date, end_date)
  end

  def senior_project_managers
    User.roles_between(['senior PM'], start_date, end_date)
  end

  def senior_quality_assurance
    User.roles_between(['senior QA'], start_date, end_date)
  end

  def android_devs
    User.billable_roles_between(['android'], start_date, end_date)
  end

  def ios_devs
    User.billable_roles_between(['iOS'], start_date, end_date)
  end

  def ror_devs
    User.billable_roles_between(['developer RoR'], start_date, end_date)
  end

  def frontend_devs
    User.billable_roles_between(['frontend'], start_date, end_date)
  end

  def designers
    User.billable_roles_between(['designer/UX'], start_date, end_date)
  end

  def project_managers
    User.roles_between(['PM'], start_date, end_date)
  end

  def quality_assurance
    User.roles_between(['QA'], start_date, end_date)
  end

  def developers_in_internals
    User.developers_in_internals_between(
      %w(developer\ RoR iOS android senior\ Android senior\ iOS senior\ RoR),
      start_date,
      end_date)
  end

  def interns
    User.roles_between(['intern'], start_date, end_date)
  end

  def junior_ror
    User.roles_between(['junior RoR'], start_date, end_date)
  end

  def junior_ios
    User.roles_between(['junior iOS'], start_date, end_date)
  end

  def junior_android
    User.roles_between(['junior android'], start_date, end_date)
  end

  def junior_frontend
    User.roles_between(['junior frontend'], start_date, end_date)
  end

  def junior_project_managers
    User.roles_between(['designer/UX'], start_date, end_date)
  end

  def junior_quality_assurance
    User.roles_between(['junior qa'], start_date, end_date)
  end

  def support_developers
    User.roles_between(['support'], start_date, end_date)
  end

  def non_billable_in_commercial_projects
    User.non_billable_in_commercial_projects_between(
      %w(developer\ RoR iOS android senior\ Android senior\ iOS senior\ RoR),
      start_date,
      end_date)
  end
end
