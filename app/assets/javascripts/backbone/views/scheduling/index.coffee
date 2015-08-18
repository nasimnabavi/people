class Hrguru.Views.SchedulingIndex extends Backbone.View
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
    @users.add(gon.users_with_rotations_in_progress, merge: true)
    @users.add(gon.users_in_commercial_projects_with_due_date, merge: true)
    @users.add(gon.booked_users, merge: true)
    @users.add(gon.unavailable_users, merge: true)
    @users.each (user) ->
      user.set('all', true)
    @roles = new Hrguru.Collections.Roles(gon.roles)

  createViews: ->
    @filters_view = new Hrguru.Views.ScheduledUsersFilters(
      @AVAILABILITY_TIME, @getAbilities(), @roles, @users
    )
    @tbodyView = new Hrguru.Views.ScheduledUsersCollectionView(@users)
    @filters_view.render()
    @tbodyView.render()

  defaultSorting: ->
    $('.default').click()

  getAbilities: ->
    gon.abilities
