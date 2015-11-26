class Hrguru.Views.UsersProjects extends Marionette.CompositeView
  template: JST['users/projects']

  itemView: Hrguru.Views.UsersProject
  emptyView: Hrguru.Views.UsersProjectEmpty
  itemViewContainer: '.projects'

  itemViewOptions: ->
    roles: @roles
    header: @header
    show_dates: @show_dates

  initialize: (options) ->
    { @roles, @header, @show_dates } = options

  serializeData: ->
    _.extend super,
      header: @header
