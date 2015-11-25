class StatisticsController < ApplicationController
  before_filter :authenticate_admin!
  expose(:position_numbers_repo) do
    PositionCountRepository.new
  end
  expose(:start_date) do
    begin
      Date.parse(params[:start])
      params[:start]
    rescue ArgumentError, TypeError
      Date.today.beginning_of_month.to_s
    end
  end
  expose(:end_date) do
    begin
      Date.parse(params[:end])
      params[:end]
    rescue ArgumentError, TypeError
      Date.today.end_of_month.to_s
    end
  end
end
