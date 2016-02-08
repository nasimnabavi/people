module Scheduling
  class UsersInCategories
    # def all
    # def juniors_and_interns
    # def to_rotate
    # def in_internals
    # def with_rotations_in_progress
    # def in_commercial_projects_with_due_date
    # def booked
    # def unavailable
    # def not_scheduled

    def method_missing(name)
      Rails.cache.fetch(name.to_sym) do
        repository.public_send(name).to_a.uniq(&:id)
      end
    end

    private

    def repository
      @repository ||= ScheduledUsersRepository.new
    end
  end
end
