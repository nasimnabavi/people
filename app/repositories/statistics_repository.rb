class StatisticsRepository
  include DatesManagement

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

  def non_billable_in_commercial_projects
    User.non_billable_in_commercial_projects_between(
      %w(developer\ RoR iOS android senior\ Android senior\ iOS senior\ RoR),
      start_date,
      end_date)
  end
end
