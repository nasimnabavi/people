module Scheduling
  class ColumnSetsBuilder
    COLUMNS = {
      'all' => %w(user role current-project from-to next-project booked notes),
      'juniors-interns' => %w(user role current-project from-to next-project notes),
      'to-rotate' => %w(user role current-project from-to notes),
      'internals' => %w(user role current-project from-to notes),
      'in-progress' => %w(user role current-project from-to next-project notes),
      'in-commercial-with-due-date' => %w(user role current-project from-to notes),
      'booked' => %w(user role current-project booked notes),
      'unavailable' => %w(user role current-project from-to next-project booked notes)
    }

    def call
      COLUMNS
    end
  end
end
