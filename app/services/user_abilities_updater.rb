class UserAbilitiesUpdater
  attr_reader :user, :new_abilities, :new_abilities_downcase

  def initialize(user_data)
    @user = User.find_by(email: user_data['email'])
    @new_abilities = user_data['skills']
    @new_abilities_downcase = @new_abilities.map(&:downcase)
  end

  def call
    return if user.blank? || old_abilities_downcase == new_abilities_downcase
    add_ability if abilities_to_add
    remove_abilities if abilities_to_remove
  end

  private

  def old_abilities_downcase
    @old_abilities_downcase ||= user.abilities.pluck(:name_downcase)
  end

  def abilities_to_add
    @abilities_to_add ||= new_abilities.select { |a| old_abilities_downcase.exclude?(a.downcase) }
  end

  def abilities_to_remove
    @abilities_to_remove ||= user.abilities.where.not(name_downcase: new_abilities_downcase)
  end

  def add_ability
    abilities = abilities_to_add.map do |new_ability|
      Ability.find_or_create_by(name_downcase: new_ability.downcase, name: new_ability)
    end
    user.abilities += abilities
  end

  def remove_abilities
    abilities_to_remove.each { |a| user.abilities.destroy(a) }
  end
end
