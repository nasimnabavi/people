module Api::V2
  class StatisticsController < Api::ApiController
    include DatesManagement
    include CollectionsSerialization

    before_filter :authenticate_admin!

    expose(:commercial_projects) { Project.commercial_between(start_date, end_date) }
    expose(:internal_projects) { Project.internal_between(start_date, end_date) }
    expose(:maintenance_projects) { Project.maintenance_between(start_date, end_date) }
    expose(:projects_ending_this_month) { Project.ends_between(start_date, end_date) }
    expose(:beginning_next_month_projects) do
      Project.beginning_between(today, thirty_days_from_today)
    end

    expose(:senior_android_devs) do
      User.billbillable_roles_between(['senior android'], start_date, end_date)
    end
    expose(:senior_ios_devs) do
      User.billbillable_roles_between(['senior iOS'], start_date, end_date)
    end
    expose(:senior_ror_devs) do
      User.billbillable_roles_between(['senior RoR'], start_date, end_date)
    end
    expose(:android_devs) do
      User.billbillable_roles_between(['android'], start_date, end_date)
    end
    expose(:ios_devs) do
      User.billbillable_roles_between(['iOS'], start_date, end_date)
    end
    expose(:ror_devs) do
      User.billbillable_roles_between(['developer RoR'], start_date, end_date)
    end
    expose(:developers_in_internals) do
      User.developers_in_internals_between(start_date, end_date)
    end
    expose(:juniors_and_interns) do
      User.roles_between(%w(intern junior\ RoR junior\ iOS junior\ android), start_date, end_date)
    end
    expose(:non_billable_in_commercial_projects) do
      User.non_billable_in_commercial_projects_between(['developer'], start_date, end_date)
    end

    def index
      @start_date = Time.zone.parse(statistics_params[:startDate])
      @end_date = Time.zone.parse(statistics_params[:endDate])
      render json: statistics_json
    end

    private

    def statistics_json
      {
        commercialProjects: serialize_projects(commercial_projects),
        internalProjects: serialize_projects(internal_projects),
        maintenanceProjects: serialize_projects(maintenance_projects),
        projectsEndingThisMonth: serialize_projects(projects_ending_this_month),
        beginningNextMonthProjects: serialize_projects(beginning_next_month_projects),
        seniorAndroidDevs: serialize_users(senior_android_devs),
        seniorIosDevs: serialize_users(senior_ios_devs),
        seniorRorDevs: serialize_users(senior_ror_devs),
        androidDevs: serialize_users(android_devs),
        iosDevs: serialize_users(ios_devs),
        rorDevs: serialize_users(ror_devs),
        developersInInternals: serialize_users(developers_in_internals),
        juniorsAndInterns: serialize_users(juniors_and_interns),
        nonBillableInCommercialProjects: serialize_users(non_billable_in_commercial_projects)
      }
    end

    def statistics_params
      params.permit(:token, :startDate, :endDate)
    end
  end
end
