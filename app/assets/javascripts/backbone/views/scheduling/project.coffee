class Hrguru.Views.ScheduledUsersProjectEmpty extends Marionette.ItemView
  template: JST['scheduling/empty_project']

  initialize: (options) ->
    @header = options.header

  serializeData: ->
    _.extend super,
      header: @header

class Hrguru.Views.ScheduledUsersProject extends Marionette.ItemView
  template: JST['scheduling/project']

  initialize: (options) ->
    @role = _.find options.roles, (role) => role.id == @model.get('membership').role_id
    @show_start_date = options.show_start_date
    @show_end_date = options.show_end_date

  serializeData: ->
    _.extend super,
      role: @role
      show_start_date: @show_start_date
      show_end_date: @show_end_date
      is_role_technical: @role?.technical
