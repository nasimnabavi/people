class Hrguru.Views.ScheduledUsersRow extends Backbone.Marionette.Layout
  tagName: 'tr'
  template: JST['scheduling/row']

  events:
    'click .user-notes': 'showUserNote'

  regions:
    projectsRegion: '.projects-region'
    nextProjectsRegion: '.next_projects-region'
    bookedProjectsRegion: '.booked_projects-region'
    userNotesRegion: '.user_notes-region'

  initialize: ->
    @highlightLongProjectMembership()
    @addInputHandler()
    @listenTo @model, 'change', @onChange
    @initVisibilitytListeners()

  highlightLongProjectMembership: ->
    return unless H.currentSchedulingCategory == 'to-rotate'
    sixMonthsAgo = moment().subtract('months', 6)
    sevenMonthsAgo = moment().subtract('months', 7)
    eightMonthsAgo = moment().subtract('months', 8)
    currentLongestMembership = moment().subtract('seconds', @model.get('seconds_of_longest_current_membership'))

    if currentLongestMembership.isBefore(eightMonthsAgo)
      @$el.addClass('rotation-needed-danger')
    else if currentLongestMembership.isBefore(sevenMonthsAgo)
      @$el.addClass('rotation-needed-warning')
    else if currentLongestMembership.isBefore(sixMonthsAgo)
      @$el.addClass('rotation-needed')

  initVisibilitytListeners: ->
    @listenTo(@model, 'toggle_visible', @toggleVisibility)

  showUserNote: (event) ->
    note = $(event.target).data('user-notes')
    $('.user-notes-content').html(note)

  serializeData: ->
    _.extend super,
      primary_role_names: _.pluck(@model.get('primary_roles'), 'name').join(', ')

  onRender: ->
    @stickit()
    role = @model.get("role")
    @toggleVisibility(@model.isActive())
    @renderProjectsRegion()
    @renderNextProjectsRegion()
    @renderBookedProjectsRegion()

  renderProjectsRegion: ->
    collectProjects = new Backbone.Collection @model.get('projects')
    projectsView = new Hrguru.Views.ScheduledUsersProjects
      collection: collectProjects
      show_start_date: true
      show_end_date: true
      header: "current"
      roles: @model.get("roles")
    @projectsRegion.show projectsView

  renderNextProjectsRegion: ->
    collectProjects = new Backbone.Collection @model.get('next_projects')
    projectsView = new Hrguru.Views.ScheduledUsersProjects
      collection: collectProjects
      show_start_date: true
      show_end_date: true
      header: "next"
      role: @model.get("role")
    @nextProjectsRegion.show projectsView

  renderBookedProjectsRegion: ->
    collectProjects = new Backbone.Collection @model.get('booked_projects')
    projectsView = new Hrguru.Views.ScheduledUsersProjects
      collection: collectProjects
      show_start_date: true
      show_end_date: true
      header: "booked"
      booked: true
      role: @model.get("role")
    @bookedProjectsRegion.show projectsView

  addInputHandler: ->
    Backbone.Stickit.addHandler
      selector: '.phone,.roles,.admin_role,.employment,.locations,.date_picker'
      events: ['change']

  onChange: ->
    attrObj = @model.changedAttributes()
    attrName = _.keys(attrObj)[0]
    $input = @$el.find(".#{attrName}")
    @model.save(attrObj,
      patch: true
      success: (model, response, options) =>
        @hideError($input)
        thName = $('table').find('th').eq($input.closest('td').index()).text()
        Messenger().success("#{thName} has been updated")
      error: (model, xhr) => @showError($input, xhr.responseJSON.errors)
    )

  showError: ($element, errorsJSON = {}) ->
    for attr, errors of errorsJSON
      Messenger().error(msg) for msg in errors
    $element.wrap("<div class='has-error'></div>") unless @hasError($element)

  hideError: ($element) ->
    $element.unwrap() if @hasError($element)

  hasError: ($element) ->
    $element.parent().is('div.has-error')

  filterEmploymentKeyPress: (event) ->
    keycode = event.keyCode
    value = "#{event.target.value}#{(H.numberFromKeyCodes(keycode))}"
    H.isNumber(keycode) and (200 >= value and value >= 0)

  filterPhoneKeyPress: (event) ->
    H.isNumber(event.keyCode)

  toggleVisibility: (state) ->
    if state then @$el.show() else @$el.hide()

  togglePotentialProject: (state) ->
    @$el.find('.project.potential').toggleClass('hide', !state)
