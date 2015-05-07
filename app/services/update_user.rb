class UpdateUser
  attr_accessor :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def call
    create_new_abilities
    set_leader_commitment

    user.attributes = params
    user.save
  end

  private

  def create_new_abilities
    # TODO: decouple this method from Selectize implementation
    return unless params['ability_ids']
    params['ability_ids'].shift
    new_abilities = params['ability_ids'].select{ |a| a.match /\D/ }
    new_abilities.each do |name|
      ability = Ability.find_or_create_by name: name
      params['ability_ids'].pop
      params['ability_ids'] << ability.id.to_s
    end
  end

  def set_leader_commitment
    return unless params['leader_team_id']

    @user = CommitmentSetter.new(user, :leader).call
  end
end
