class CommitmentSetter
  attr_reader :user, :role_name

  COMMITMENT = {
    junior: 40,
    developer: 38,
    senior: 35,
    leader: 30
  }

  def initialize(user, role_name)
    @user = user
    @role_name = role_name
  end

  def call
    user.commitment = COMMITMENT[role_name] if COMMITMENT[role_name]

    user
  end
end
