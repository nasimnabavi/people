class Hrguru.Views.UsersProjectEmpty extends Marionette.ItemView
  template: JST['users/empty_project']

  initialize: (options) ->
    @header = options.header

  serializeData: ->
    _.extend super,
      header: @header

class Hrguru.Views.UsersProject extends Marionette.ItemView
  template: JST['users/project']

  initialize: (options) ->
    @roles = options.roles
    @show_dates = options.show_dates
    roleId = @model.get('membership').role_id
    @role = @roles.filter((role) => role.id == roleId)[0]

  serializeData: ->
    _.extend super,
      role: @role
      show_dates: @show_dates
      is_role_technical: @role? && @role.technical
      show_nonbillable_sign: !(@model.get('billable') || @model.get('project').internal)
