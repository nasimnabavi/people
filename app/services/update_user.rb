class UpdateUser
  attr_accessor :user, :params, :current_user

  def initialize(user, params, current_user)
    @user = user
    @params = params
    @current_user = current_user
  end

  def call
    create_new_abilities
    set_leader_commitment

    user.attributes = params
    notify_admins_about_changes if user.employment_changed? || user.location_id_changed?
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
      index = params['ability_ids'].index(name)
      params['ability_ids'][index] = ability.id.to_s
    end
  end

  def set_leader_commitment
    return unless params['leader_team_id']

    @user = CommitmentSetter.new(user, :leader).call
  end

  def notify_admins_about_changes
    SendMailJob.new.async.perform_with_user(UserMailer, :employment_or_location_changed, user, current_user)
  end
end
