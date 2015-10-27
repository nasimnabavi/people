module DatesManagement
  extend ActiveSupport::Concern

  attr_reader :start_date, :end_date

  def today
    Time.now.beginning_of_day
  end

  def thirty_days_from_today
    today + 30.days
  end
end
