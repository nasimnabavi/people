class Hrguru.Views.RoleChoiceModalView extends Marionette.ItemView
  template: JST['dashboard/projects/memberships/role_choice_modal']

  events:
    'click .js-new-membership-role-choice-submit': (e) -> @addNewMember(e)

  initialize: (options) ->
    @roles = options.roles
    @newMembershipAttributes = options.attributes
    @onSubmit = options.onSubmit

  onShow: ->
    @$el.find('.modal').modal('show')

  serializeData: ->
    roles = @roles.map (role) -> role.toJSON()
    $.extend(super, { roles: roles })

  addNewMember: (e) ->
    e.preventDefault()
    attrs = _.clone(@newMembershipAttributes)
    attrs.role_id = @$el.find('select').val()
    @onSubmit?(attrs)
    @close()
