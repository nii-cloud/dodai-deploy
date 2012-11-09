set_node_props = (name_sel) ->
  current_name = name_sel.val()
  $.each node_candidates, ->
    if @name == current_name
      $("#node_ip").val @ip
      $("#node_os").val @os
      $("#node_os_version").val @os_version
      false

$ ->
  $("#node_name").change ->
    set_node_props $(this)

  set_node_props $("#node_name")
