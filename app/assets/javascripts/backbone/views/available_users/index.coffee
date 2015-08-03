class Hrguru.Views.AvailableUsersIndex extends Backbone.View
  AVAILABILITY_TIME: [
    { text: 'All', value: 100000 }
    { text: 'From now', value: 0 }
    { text: '1 week',   value: moment.duration(1, 'week').asDays() }
    { text: '2 weeks',  value: moment.duration(2, 'weeks').asDays() }
    { text: '1 month',  value: moment.duration(1, 'month').asDays() }
    { text: '2 months', value: moment.duration(2, 'months').asDays() }
  ]

  el: '#main-container'

  initialize: ->
    @createCollections()
    @createViews()
    @defaultSorting()

  createCollections: ->
    @users = new Hrguru.Collections.Users()
    @users.add(gon.juniors_and_interns, merge: true)
    @users.add(gon.users_to_rotate, merge: true)
    @users.add(gon.users_in_internals, merge: true)
    @roles = new Hrguru.Collections.Roles(gon.roles)

  createViews: ->
    @filters_view = new Hrguru.Views.AvailableUsersFilters(
      @AVAILABILITY_TIME, @getAbilities(), @roles
    )
    @filters_view.render()
    @tbodyView = new Hrguru.Views.AvailableUsersCollectionView(@users)
    @tbodyView.render()

  defaultSorting: ->
    $('.default').click()

  getAbilities: ->
    gon.abilities
