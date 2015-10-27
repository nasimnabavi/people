module Api::V2
  class StatisticsController < Api::ApiController
    include DatesManagement
    include CollectionsSerialization

    before_filter :authenticate_admin!

    expose(:commercial_projects) { Project.commercial_between(start_date, end_date) }
    expose(:internal_projects) { Project.internal_between(start_date, end_date) }
    expose(:projects_ending_this_month) { Project.ends_between(start_date, end_date) }
    expose(:beginning_next_month_projects) { Project.beginning_between(today, thirty_days_from_today) }

    expose(:billable_developers) { [] }
    expose(:developers_in_internals) { [] }
    expose(:juniors_and_interns) { [] }

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
        projectsEndingThisMonth: serialize_projects(projects_ending_this_month),
        beginningNextMonthProjects: serialize_projects(beginning_next_month_projects),
        billableDevelopers: billable_developers,
        developersInInternals: developers_in_internals,
        juniorsAndInterns: juniors_and_interns
      }
    end

    def statistics_params
      params.permit(:token, :startDate, :endDate)
    end
  end
end
