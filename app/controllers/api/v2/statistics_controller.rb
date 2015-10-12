module Api::V2
  class StatisticsController < Api::ApiController
    expose(:commercial_projects_number) {
      Project.commercial.starts_before(end_of_month).ends_after(beginning_of_month).count
    }
    expose(:internal_projects_number) {
      Project.internal.starts_before(end_of_month).ends_after(beginning_of_month).count
    }
    expose(:projects_ending_this_month_number) {
      Project.ends_after(beginning_of_month).ends_before(end_of_month).count
    }
    expose(:beginning_next_month_projects_number) {
      Project.potential.starts_after(beginning_of_next_month).starts_before(end_of_next_month).count
    }

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
        beginningNextMonthProjectsNumber: beginning_next_month_projects_number
      }
    end

    def beginning_of_month
      @date.beginning_of_month
    end

    def end_of_month
      @date.end_of_month
    end

    def beginning_of_next_month
      next_month.beginning_of_month
    end

    def end_of_next_month
      next_month.end_of_month
    end

    def next_month
      @date.next_month
    end

    def statistics_params
      params.permit(:token, :date)
    end
  end
end
