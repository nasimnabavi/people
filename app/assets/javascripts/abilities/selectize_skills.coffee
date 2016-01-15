removeFormControlClass = ->
  $('#js-user-abilities').removeClass('form-control')

initializeAbilities = ->
  selectize = $('#js-user-abilities').selectize
    plugins: if gon.fetching_abilities then [] else ['remove_button', 'drag_drop']
    delimiter: ','
    persist: false
    create: (input) ->
      value: input
      text: input
  selectize[0].selectize.lock() if gon.fetching_abilities

$ ->
  removeFormControlClass()
  initializeAbilities()
