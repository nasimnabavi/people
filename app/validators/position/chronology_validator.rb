class Position
  class ChronologyValidator < ActiveModel::Validator
    def validate(record)
      return if record.errors.any? || chronology_valid?(record)

      record.errors.add(:starts_at, I18n.t('positions.errors.chronology'))
    end

    private

    def chronology_valid?(position)
      positions = Position.includes(:role).where(user: position.user).order(:starts_at)
        .pluck('positions.starts_at, roles.priority')
      previous_positions_have_less_or_equal_priority?(positions, position) &&
        next_positions_have_greater_or_equal_priority?(positions, position)
    end

    def previous_positions_have_less_or_equal_priority?(positions, position)
      positions.select do |p|
        p[0] < position.starts_at
      end.all? { |p| p[1] >= position.role.priority }
    end

    def next_positions_have_greater_or_equal_priority?(positions, position)
      positions.select do |p|
        p[0] > position.starts_at
      end.all? { |p| p[1] <= position.role.priority }
    end
  end
end
