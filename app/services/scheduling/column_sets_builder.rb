module Scheduling
  class ColumnSetsBuilder
    def call
      COLUMNS
    end

    private

    USER = 'User'.freeze
    ROLE = 'Role'.freeze
    CURRENT = 'Current project'.freeze
    NEXT = 'Next project'.freeze
    BOOKED = 'Booked'.freeze
    NOTES = 'Notes'.freeze

    COLUMNS = {
      'all' => [USER, ROLE, CURRENT, NEXT, BOOKED, NOTES],
      'juniors_and_interns' => [USER, ROLE, CURRENT, NEXT, NOTES],
      'to_rotate' => [USER, ROLE, CURRENT, NOTES],
      'in_internals' => [USER, ROLE, CURRENT, NEXT, NOTES],
      'with_rotations_in_progress' => [USER, ROLE, CURRENT, NEXT, NOTES],
      'in_commercial_projects_with_due_date' => [USER, ROLE, CURRENT, NEXT, NOTES],
      'booked' => [USER, ROLE, CURRENT, BOOKED, NOTES],
      'unavailable' => [USER, ROLE, CURRENT, NEXT, BOOKED, NOTES],
      'not_scheduled' => [USER, ROLE, CURRENT, BOOKED, NOTES]
    }
  end
end
