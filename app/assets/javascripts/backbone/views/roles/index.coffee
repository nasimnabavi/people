class Hrguru.Views.RolesIndex extends Backbone.View
  el: '#main-container'

  events:
    'click #add-role': 'addItem'

  initialize: ->
    @rolesListView = new Marionette.CollectionView
      collection: new Hrguru.Collections.Roles(gon.roles)
      itemView: Hrguru.Views.RolesRow
      emptyView: Hrguru.Views.RolesEmptyRow
      el: @$('ul#roles')
      tagName: 'ul'

    @rolesListView.render()

  addItem: (event) ->
    event.preventDefault()
    $input = $('#name')
    $selectPriority = $('#priority')
    $checkboxBillable = $('#billable')
    $checkboxTechnical = $('#technical')
    $checkboxShowInTeam = $('#show-in-team')
    role = new Hrguru.Models.Role()
    role.save(
      {
        name: $input.val(),
        priority: $selectPriority.val(),
        billable: $checkboxBillable.prop('checked'),
        technical: $checkboxTechnical.prop('checked'),
        show_in_team: $checkboxShowInTeam.prop('checked')
      }
      {
        success: =>
          $input.val("")
          @rolesListView.collection.add role
        error: =>
          Messenger().error("Cannot create role")
      }
    )
