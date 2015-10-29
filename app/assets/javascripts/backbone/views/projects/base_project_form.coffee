class Hrguru.Views.BaseProjectForm extends Backbone.View

  el: '#main-container'

  events:
    'change #project_project_type' : 'toggleProjectMaintenanceDate'

  toggleProjectMaintenanceDate: (event) ->
    if $(event.target).val() == 'maintenance'
      $('#maintenance_wrapper').removeClass('hidden')
    else
      $('#maintenance_wrapper').addClass('hidden')
