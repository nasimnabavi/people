module Memberships
  class UpdateBookedAt
    def initialize(membership)
      @membership = membership
    end

    def call
      booked_date = @membership.booked ? @membership.starts_at : nil
      @membership.booked_at = booked_date
    end
  end
end
