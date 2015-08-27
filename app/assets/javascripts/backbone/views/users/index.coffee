class Hrguru.Views.UsersIndex extends Backbone.View
  el: '#main-container'

  events:
    "click .js-fetch-abilities" : "fetchAbilities"

  initialize: ->
    @createCollections()
    @createViews()
    @defaultSorting()

  createCollections: ->
    @users = new Hrguru.Collections.Users(gon.users)
    @active_users = @users.active()
    @projects = new Hrguru.Collections.Projects(gon.projects)
    @roles = new Hrguru.Collections.Roles(gon.roles)

  createViews: ->
    @filters_view = new Hrguru.Views.UsersFilters(@projects, @roles, @users, gon.locations,
      gon.abilities, gon.months)
    @filters_view.render()
    @tbodyView = new Hrguru.Views.UsersCollectionView(@users)
    @tbodyView.render()

  defaultSorting: ->
    $('.default').click()

  fetchAbilities: (e) ->
    e.preventDefault()
    alert('Synchronization will run in background. It may take a while.')
    $.ajax
      type: 'GET'
      url: e.target.href
