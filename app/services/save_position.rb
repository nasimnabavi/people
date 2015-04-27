class SavePosition
  attr_accessor :position

  COMMITMENT = {
    junior: 40,
    developer: 38,
    senior: 35
  }

  def initialize(position)
    self.position = position
  end

  def call
    update_user_commitment if position.user_id
    position.save
  end

  private

  def update_user_commitment
    user = position.user
    user.update commitment: COMMITMENT[position.role.name.to_sym]
  end
end
