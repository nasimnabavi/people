changeMaintenanceState = ->
  $('#project_project_type').change (event) ->
    if $(event.target).val() == 'maintenance'
      $('#maintenance_wrapper').removeClass('hidden')
    else
      $('#maintenance_wrapper').addClass('hidden')

$ ->
  changeMaintenanceState()
