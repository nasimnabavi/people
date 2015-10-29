class Hrguru.Views.ModalView extends Marionette.ItemView
  template: JST['teams/_form']

  events:
    'click .js-edit-team-submit': (e) -> @updateTeam(e)
    'click .js-remove-team': (e) -> @removeTeam(e)

  initialize: (options) ->
    @team = options.team

  onShow: ->
    @$el.find('.modal').modal('show')

  updateTeam: (e) ->
    e.preventDefault()

    newName = @$el.find('input').val()
    @team.save name: newName,
      wait: true
      success: @teamNameChanged
      error: @teamError
    @close()

  removeTeam: (e) ->
    e.preventDefault()

    @team.destroy
      wait: true
      success: @teamRemoved
      error: @teamError
    @close()

  teamNameChanged: (team) =>
    Messenger().success("We successfully changed team's name to #{team.get('name')}")

  teamRemoved: (team) =>
    Messenger().success("We successfully removed team #{team.get('name')}")

  teamError: (model, xhr) ->
    Messenger().error(xhr.responseJSON.errors)
