class SavePosition
  attr_reader :position

  def initialize(position)
    @position = position
  end

  def call
    position.save && update_user_commitment
  end

  private

  def update_user_commitment
    user = CommitmentSetter.new(position.user,
      position.role.name.to_sym).call

    user.save
  end
end
