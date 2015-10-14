module DatesManagement
  extend ActiveSupport::Concern

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
end
