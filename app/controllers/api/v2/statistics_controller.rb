module Api::V2
  class StatisticsController < Api::ApiController
    include DatesManagement

    respond_to :json
    before_filter :authenticate_admin!

    expose(:commercial_projects) { Project.commercial_between(start_date, end_date) }
    expose(:internal_projects) { Project.internal_between(start_date, end_date) }
    expose(:maintenance_projects) { Project.maintenance_between(start_date, end_date) }
    expose(:projects_ending_between) { Project.ends_between(start_date, end_date) }
    expose(:beginning_soon_projects) do
      Project.beginning_between(today, thirty_days_from_today)
    end

    expose(:senior_android_devs) do
      User.billable_roles_between(['senior android'], start_date, end_date)
    end
    expose(:senior_ios_devs) do
      User.billable_roles_between(['senior iOS'], start_date, end_date)
    end
    expose(:senior_ror_devs) do
      User.billable_roles_between(['senior RoR'], start_date, end_date)
    end
    expose(:android_devs) do
      User.billable_roles_between(['android'], start_date, end_date)
    end
    expose(:ios_devs) do
      User.billable_roles_between(['iOS'], start_date, end_date)
    end
    expose(:ror_devs) do
      User.billable_roles_between(['developer RoR'], start_date, end_date)
    end
    expose(:developers_in_internals) do
      User.developers_in_internals_between(start_date, end_date)
    end
    expose(:interns) do
      User.roles_between(['intern'], start_date, end_date)
    end
    expose(:junior_ror) do
      User.roles_between(['junior RoR'], start_date, end_date)
    end
    expose(:junior_ios) do
      User.roles_between(['junior iOS'], start_date, end_date)
    end
    expose(:junior_android) do
      User.roles_between(['junior android'], start_date, end_date)
    end
    expose(:non_billable_in_commercial_projects) do
      User.non_billable_in_commercial_projects_between(
        %w(developer\ RoR iOS android senior\ Android senior\ iOS senior\ RoR),
        start_date,
        end_date)
    end

    def index
      @start_date = Time.zone.parse(statistics_params[:startDate])
      @end_date = Time.zone.parse(statistics_params[:endDate])
      render 'api/v2/statistics/index'
    end

    private

    def statistics_params
      params.permit(:token, :startDate, :endDate)
    end
  end
end
