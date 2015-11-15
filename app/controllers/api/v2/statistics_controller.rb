module Api::V2
  class StatisticsController < Api::ApiController
    include DatesManagement

    respond_to :json
    before_filter :authenticate_admin!

    expose(:statistics) { StatisticsRepository.new(start_date, end_date) }

    def index
      @start_date = Time.zone.parse(statistics_params[:startDate])
      @end_date = Time.zone.parse(statistics_params[:endDate])
      render json: statistics, serializer: Repositories::StatisticsRepositorySerializer, root: false
    end

    private

    def statistics_params
      params.permit(:token, :startDate, :endDate)
    end
  end
end
