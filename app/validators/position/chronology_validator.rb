class Position
  class ChronologyValidator < ActiveModel::Validator
    def validate(record)
      return if record.errors.any? || chronology_valid?(record.user)

      record.errors.add(:starts_at, I18n.t('positions.errors.chronology'))
    end

    private

    def chronology_valid?(user)
      current_positions = sorted_position_names_for(user)
      current_positions == expected_positions_order(current_positions)
    end

    def sorted_position_names_for(user)
      Position.includes(:role).where(user: user).order(:starts_at).pluck('roles.name')
    end

    def expected_positions_order(positions)
      Role.where(name: positions).order(:priority).pluck(:name).reverse
    end
  end
end
