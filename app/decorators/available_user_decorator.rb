class AvailableUserDecorator < UserDecorator
  def seconds_of_longest_current_membership
    return 0 if longest_current_membership.nil?
    (Time.now - longest_current_membership.starts_at.to_time).to_i
  end

  def self.model_name
    ActiveModel::Name.new(User)
  end
end
