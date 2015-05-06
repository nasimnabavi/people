class UpdateUser
  attr_accessor :user, :params

  def initialize(user, params)
    self.user = user
    self.params = params
  end

  def call
    create_new_abilities
    update_leader_commitment
    user.update(params)
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

  def update_leader_commitment
    params['commitment'] = 30 if params['leader_team_id']
  end
end
