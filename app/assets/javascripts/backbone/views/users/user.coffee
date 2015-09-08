class Hrguru.Views.UsersShow extends Backbone.View
  el: '#user'

  initialize: ->
    @displayDefaultGravatar()
    @removeFormControlClass()
    @initializeAbilities()
    @observePrimaryRoleChange()
    elTimeline = @$('.timeline')
    @timeline = elTimeline.timeline(gon.events)
    elTimeline.scrollTo(elTimeline[0].scrollWidth, 0)
    @$el.after @timeline

  removeFormControlClass: ->
    @$('#js-user-abilities').removeClass('form-control')

  initializeAbilities: ->
    selectize = @$('#js-user-abilities').selectize
      plugins: if gon.fetching_abilities then [] else ['remove_button', 'drag_drop']
      delimiter: ','
      persist: false
      create: (input) ->
        value: input
        text: input
    selectize[0].selectize.lock() if gon.fetching_abilities

  displayDefaultGravatar: ->
    $('.img-rounded').error ->
      $(@).attr('src', 'http://www.gravatar.com/avatar')

  observePrimaryRoleChange: ->
    $('.primary-toggle').change ->
      $(this).parents('form').submit()
