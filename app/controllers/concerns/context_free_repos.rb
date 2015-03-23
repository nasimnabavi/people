module ContextFreeRepos
  extend ActiveSupport::Concern

  included do
    expose(:users_repository) { UserRepository.new }
    expose(:projects_repository) { ProjectsRepository.new }
    expose(:locations_repository) { LocationsRepository.new }
    expose(:abilities_repository) { AbilitiesRepository.new }
    expose(:roles_repository) { RolesRepository.new }
    expose(:contract_types_repository) { ContractTypesRepository.new }
  end
end
