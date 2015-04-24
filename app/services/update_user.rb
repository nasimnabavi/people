class UpdateUser
  attr_accessor :user, :params

  def initialize(user, params)
    self.user = user
    self.params = params
  end

  def call
    create_new_abilities
    user.attributes = params
    user.save
  end

  private

  def create_new_abilities
    # TODO: decouple this method from Selectize implementation
    if params['ability_ids']
      params['ability_ids'].shift
      new_abilities = params['ability_ids'].select{ |a| a.match /\D/ }
      new_abilities.each do |name|
        ability = Ability.find_or_create_by name: name
        params['ability_ids'].pop
        params['ability_ids'] << ability.id.to_s
      end
    end
  end
end
