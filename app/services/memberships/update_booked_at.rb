module Memberships
  class UpdateBookedAt
    def initialize(membership)
      @membership = membership
    end

    def call
      return unless @membership.booked_changed?
      booked_date = @membership.booked ? Time.zone.now : nil
      @membership.booked_at = booked_date
    end
  end
end
