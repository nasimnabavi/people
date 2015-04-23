class PositionDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  decorates_association :role

  def starts_at_date
    starts_at.to_date
  end
end
