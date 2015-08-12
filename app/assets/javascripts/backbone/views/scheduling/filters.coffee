class Hrguru.Views.AvailableUsersFilters extends Marionette.View
  el: '#filters'

  events:
    'click .category': 'activateCategory'

  ui:
    tabs: '.category'

  initialize: (@availability_time, @abilities, @roles) ->
    @initializeVariables()
    @bindUIElements()

  initializeVariables: ->
    @selectize =
      availability_time: []
      abilities: []
      roles: []
      category: ''

  render: ->
    @initializeAvailabilityTimeFilter()
    @initializeAbilitiesFilter()
    @initializeRoleFilter()

  activateCategory: (e) ->
    $tab = $(e.target).parent()
    return unless $tab.hasClass('category')
    @ui.tabs.removeClass('active')
    $tab.addClass('active')
    @selectize.category = $tab.data('category')
    if @selectize.category == 'to-rotate'
      @sortUsers('seconds_of_longest_current_membership', 0)
    @filterUsers()

  initializeAvailabilityTimeFilter: ->
    availability_time_selectize = @$('select[name=availability_time]').selectize
      valueField: 'value'
      labelField: 'text'
      options: @availability_time
    availability_time_selectize.change @, @updateSelectizeAvailability
    @selectize.availability_time = availability_time_selectize[0].selectize.items[0]

  initializeRoleFilter: ->
    roles_selectize = @$('input[name=roles]').selectize
      plugins: ['remove_button']
      valueField: 'id'
      labelField: 'name'
      searchField: 'name'
      sortField: 'priority'
      options: @roles.toJSON()
      onItemAdd: @filterUsers
      onItemRemove: @filterUsers
    @selectize.roles = roles_selectize[0].selectize.items

  initializeAbilitiesFilter: ->
    abilities_selectize = @$('input[name=abilities]').selectize
      plugins: ['remove_button']
      valueField: 'id'
      labelField: 'name'
      searchField: 'name'
      sortField: 'name'
      options: @abilities
      onItemAdd: @filterUsers
      onItemRemove: @filterUsers
    @selectize.abilities = abilities_selectize[0].selectize.items

  updateSelectizeAvailability: (e) =>
    @selectize.availability_time = $(e.target).first().val()
    @filterUsers()

  filterUsers: =>
    EventAggregator.trigger('users:updateVisibility', @selectize)
    H.addUserIndex()

  sortUsers: (attr, direction) ->
    EventAggregator.trigger('availableUsers:sort', attr, direction)
