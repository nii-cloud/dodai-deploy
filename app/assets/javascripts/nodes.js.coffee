set_node_name = (name_sel) ->
  current_name = name_sel.val()
  $.each node_candidates, ->
    if @name == current_name
      $("#node_ip").val @ip
      false

$ ->
  $("#node_name").change ->
    set_node_name $(this)

  set_node_name $("#node_name")
