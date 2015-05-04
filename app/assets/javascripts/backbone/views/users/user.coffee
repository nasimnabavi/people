class Hrguru.Views.UsersShow extends Backbone.View
  el: '#user'

  initialize: ->
    @displayDefaultGravatar()
    @removeFormControlClass()
    @initializeAbilities()
    elTimeline = @$('.timeline')
    @timeline = elTimeline.timeline(gon.events)
    elTimeline.scrollTo(elTimeline[0].scrollWidth, 0)
    @$el.after @timeline

  removeFormControlClass: ->
    @$('#js-user-abilities').removeClass('form-control')

  initializeAbilities: ->
    @$('#js-user-abilities').selectize
      plugins: ['remove_button', 'drag_drop']
      delimiter: ','
      persist: false
      create: (input) ->
        value: input
        text: input

  displayDefaultGravatar: ->
    $('.img-rounded').error ->
      $(@).attr('src', 'http://www.gravatar.com/avatar')
