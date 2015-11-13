class Hrguru.Models.User extends Backbone.Model

  visibleBy:
    users: true
    roles: true
    actualProjects: true
    oldProjects: true
    abilities: true
    months_in_current_project: true
    category: true

  membership: null

  initialize: ->
    super
    @next_projects = new Hrguru.Models.Project(@get('next_projects'))
    @listenTo(EventAggregator, 'users:updateVisibility', @updateVisibility)

  updateVisibility: (data) ->
    @visibleBy.roles = @visibleByRoles(data.roles)
    @visibleBy.actualProjects = @visibleByProjects(data.actualProjects)
    @visibleBy.oldProjects = @visibleByOldProjects(data.oldProjects)
    @visibleBy.users = @visibleByUsers(data.users)
    @visibleBy.abilities = @visibleByAbilities(data.abilities)
    @visibleBy.months_in_current_project = @visibleByMonthsInCurrentProject(parseInt(data.months))
    @visibleBy.category = @visibleByCategory(data.category)
    @trigger 'toggle_visible', @isVisible()

  isVisible: ->
    @visibleBy.roles && @visibleBy.actualProjects && @visibleBy.users &&
      @visibleBy.abilities && @isActive() && @visibleBy.months_in_current_project &&
      @visibleBy.category && @visibleBy.oldProjects

  visibleByUsers: (users = '') ->
    return true if users.length == 0
    String(@id) in users

  visibleByRoles: (roles = '') ->
    return true if roles.length is 0
    roles = _.intersection roles, @myRoles()
    return true if roles.length > 0

  visibleByProjects: (projects = '') ->
    return true if projects.length == 0
    return false unless @get('projects')?
    myProjects = @myProjects()
    (_.difference myProjects, projects).length < myProjects.length

  visibleByOldProjects: (projects = '') ->
    return true if projects.length == 0
    return false unless @get('projects')?
    myProjects = @myOldProjects()
    (_.difference myProjects, projects).length < myProjects.length

  visibleByAbilities: (abilities = '') ->
    return true if abilities.length == 0
    return false unless @get('abilities')?
    myAbilities = @myAbilities()
    (_.union myAbilities, abilities).length == myAbilities.length

  visibleByMonthsInCurrentProject: (months = '') ->
    return true if months == 0
    @isInProjectForMoreThanMonths(months)

  visibleByCategory: (category = '') ->
    return true if category == 'all' || category == ''
    return false unless @get(category)?
    @get(category)

  myProjects: ->
    _.map @get("projects"), (p) -> String(p.project.id)

  myOldProjects: ->
    _.map @get("previous_projects"), (p) -> String(p.project.id)

  myRole: ->
    String(@get("role").id)

  myRoles: ->
    _.map _.pluck(@get('primary_roles'), 'id'), (r) -> String(r)

  myAbilities: ->
    _.map @get("abilities"), (a) -> String(a.id)

  isActive: ->
    !@get('archived')

  hasRole: ->
    @get('role_id') != null

  isInProjectForMoreThanMonths: (months) ->
    return true if isNaN(months)
    @get('months_in_current_project') > months

  hasTechnicalRole: ->
    @get('role').technical

  isPotential: ->
    return false unless @hasTechnicalRole()
    if @get('has_project') && !@hasProjectsOnlyPotentialOrNotbillable()
      return false unless @membership.hasEndDate()
    (!@hasNextProjects() || @nextProjectsOnlyPotentialOrNotbillable())

  hasNextProjects: ->
    @next_projects?

  hasProjectsOnlyPotentialOrNotbillable: ->
    @areOnlyPotenialOrNotbillable(@get('projects'))

  nextProjectsOnlyPotentialOrNotbillable: ->
    @areOnlyPotenialOrNotbillable(@next_projects)

  areOnlyPotenialOrNotbillable: (projects) ->
    _.all projects, (project) =>
      @userProjectIsPotential(project) or !@userProjectIsBillable(project)

  userProjectIsPotential: (next_project) ->
    next_project.project.potential

  userProjectIsBillable: (current_project) ->
    current_project.billable

class Hrguru.Collections.Users extends Backbone.Collection
  model: Hrguru.Models.User
  url: Routes.users_path()

  sortAttribute: 'name'
  sortDirection: 1

  sortUsers: (attr, direction) ->
    @sortAttribute = attr
    @sortDirection = direction
    @sort()
    return

  comparator: (a, b) ->
    a = a.get(@sortAttribute)
    b = b.get(@sortAttribute)

    a = '' unless a
    b = '' unless b

    if isNaN(a) && isNaN(b)
      @compareStrings(a, b)
    else
      @compareNumbers(a, b)

  compareDates: (a, b) ->
    result = 0
    if a.isBefore(b) then result = 1 else result = -1
    if @sortDirection is 1 then result else -result

  compareStrings: (a, b) ->
    aDate = moment(a)
    bDate = moment(b)

    return @compareDates(aDate, bDate) if aDate.isValid() && bDate.isValid()

    if @sortDirection is 1
      a.localeCompare(b)
    else
      -a.localeCompare(b)

  compareNumbers: (a, b) ->
    result = 0

    if a >= b then result = 1 else result = -1
    if @sortDirection is 1 then result else -result

  numbers_comparator: (a, b) ->
    if a >= b then 1 else -1

  active: ->
    filtered = @filter((user) ->
      user.isActive()
    )
    new Hrguru.Collections.Users(filtered)

  inSchedulingCategory: (category) ->
    filtered = @filter (user) ->
      user.get(category)
    new Hrguru.Collections.Users(filtered)

  withRole: ->
    filtered = @filter((user) ->
      user.hasRole()
    )
    new Hrguru.Collections.Users(filtered)
