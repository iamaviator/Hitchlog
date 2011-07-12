$(document).ready ->
  init_map()
  $("#trip_from").observe_field 0.3, ->
    if this.value.length > 1
      get_location $("#trip_from").val(), $("#suggest_from"), "from"

  $("#trip_to").observe_field 0.3, ->
    if this.value.length > 1
      get_location $("#trip_to").val(), $("#suggest_to"), "to"

  $("#trip_to").change ->
    if this.value.length > 1
      set_new_route()
      $("#km_display").show()

  # Suggestions currently disabled:
  $('#suggest_from a').live 'click', ->
    $("#trip_from").val($(this).html())
    return false

  $('#suggest_to a').live 'click', ->
    $("#trip_to").val($(this).html())
    return false

  return