module Api::V2
  class StatisticsController < Api::ApiController
    include DatesManagement
    include CollectionsSerialization

    before_filter :authenticate_admin!

    expose(:commercial_projects) { Project.commercial_between(beginning_of_month, end_of_month) }
    expose(:internal_projects) { Project.internal_between(beginning_of_month, end_of_month) }
    expose(:projects_ending_this_month) { Project.ends_between(beginning_of_month, end_of_month) }
    expose(:beginning_next_month_projects) do
      Project.beginning_between(beginning_of_next_month, end_of_next_month)
    end

    expose(:billable_developers) { [] }
    expose(:developers_in_internals) { [] }
    expose(:juniors_and_interns) { [] }

    def index
      @date = DateTime.parse("#{statistics_params[:date]}-1")
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
      params.permit(:token, :date)
    end
  end
end
