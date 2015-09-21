class Hrguru.Views.ScheduledUsersProjects extends Marionette.CompositeView
  template: JST['scheduling/projects']

  itemView: Hrguru.Views.ScheduledUsersProject
  emptyView: Hrguru.Views.ScheduledUsersProjectEmpty
  itemViewContainer: '.projects'

  itemViewOptions: ->
    roles: @roles
    header: @header
    show_start_date: @show_start_date
    show_end_date: @show_end_date

  initialize: (options) ->
    { @roles, @header, @show_start_date, @show_end_date } = options

  serializeData: ->
    _.extend super,
      header: @header
