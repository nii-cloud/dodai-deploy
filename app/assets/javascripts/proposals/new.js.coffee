$ ->
  $("#proposal_software_id").change ->
    document.location = "?software=" + @value

  init_add_delete_buttons()
