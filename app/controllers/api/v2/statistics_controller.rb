module Api::V2
  class StatisticsController < Api::ApiController
    include DatesManagement

    before_filter :authenticate_admin!

    expose(:commercial_projects_number) do
      Project.commercial_between(beginning_of_month, end_of_month).count
    end
    expose(:internal_projects_number) do
      Project.internal_between(beginning_of_month, end_of_month).count
    end
    expose(:projects_ending_this_month_number) do
      Project.ends_between(beginning_of_month, end_of_month).count
    end
    expose(:beginning_next_month_projects_number) do
      Project.beginning_between(beginning_of_next_month, end_of_next_month).count
    end

    expose(:billable_developers_number) { 0 }
    expose(:developers_in_internals_number) { 0 }
    expose(:juniors_and_interns_number) { 0 }

    def index
      @date = DateTime.parse("#{statistics_params[:date]}-1")
      render json: statistics_json
    end

    private

    def statistics_json
      {
        commercialProjectsNumber: commercial_projects_number,
        internalProjectsNumber: internal_projects_number,
        projectsEndingThisMonthNumber: projects_ending_this_month_number,
        beginningNextMonthProjectsNumber: beginning_next_month_projects_number,
        billableDevelopersNumber: billable_developers_number,
        developersInInternalsNumber: developers_in_internals_number,
        juniorsAndInternsNumber: juniors_and_interns_number
      }
    end

    def statistics_params
      params.permit(:token, :date)
    end
  end
end
