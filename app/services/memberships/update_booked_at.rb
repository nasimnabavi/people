module Memberships
  class UpdateBookedAt
    def initialize(membership)
      @membership = membership
    end

    def call
      booked_date = @membership.booked ? date_with_current_hour : nil
      @membership.booked_at = booked_date
    end

    private

    def date_with_current_hour
      starts_at = @membership.starts_at
      Time.now.change(
        year: starts_at.year,
        month: starts_at.month,
        day: starts_at.day
      )
    end
  end
end
