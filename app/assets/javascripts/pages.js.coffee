$("#select_all").on 'change', ->
  $('input.exportable').prop 'checked', $(@).prop("checked")