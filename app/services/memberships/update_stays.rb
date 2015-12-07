module Memberships
  class UpdateStays
    def initialize(project_id, membership_ids)
      @project_id = project_id
      @membership_ids = membership_ids
    end

    def call
      return if @membership_ids.nil?
      Membership.where.not(id: clear_ids).where(project_id: @project_id).update_all(stays: false)
      Membership.where(id: clear_ids).update_all(stays: true)
    end

    private

    def clear_ids
      @membership_ids.reject { |id| id.empty? }
    end
  end
end
