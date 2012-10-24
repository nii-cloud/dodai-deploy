window.add_node_config = (add_btn) ->
  node_config_table = add_btn.parent().parent().find(".node_config_table")
  node_config_tr = node_config_table.find(".node_config_tr:last")
  node_config_number = node_config_table.find(".node_config_tr").size()
  node_size = node_config_tr.find("option").size()
  console.debug "Node size: " + node_size

  if node_config_number >= node_size
    alert "The node can't be added because the number of nodes added is larger than or equals to total number of nodes."
    return

  new_node_config_tr = node_config_tr.clone()
  index = max_node_config_index_number() + 1
  old_index = new_node_config_tr.find("select").attr("id").split("_")[4]
  html = new_node_config_tr.html()
  console.debug html

  html = html.replaceAll("_" + old_index, "_" + index)
  html = html.replaceAll("[" + old_index, "[" + index)
  html = html.replace("installed", "init")
  selected_index = node_config_tr.find("select").prop("selectedIndex")
  console.debug html

  new_node_config_tr.html html
  node_config_tr.parent().append new_node_config_tr
  found_selected = false
  console.debug selected_index
  node_config_tr.parent().find(".node_config_tr:last").find("select").prop "selectedIndex", Math.min(selected_index + 1, node_size - 1)


window.delete_node_config = (delete_btn) ->
  if delete_btn.parentsUntil("table").find(".node_config_tr").size() <= 1
    alert "At least one node should be left."
    return
  delete_btn.parent().parent().next(":hidden").remove()
  delete_btn.parent().parent().remove()


window.init_add_delete_buttons = ->
  $(".add_btn").live "click", ->
    add_node_config $(this)

  $(".delete_btn").live "click", ->
    delete_node_config $(this)


window.max_node_config_index_number = ->
  max_index = 0
  $(".node_config_tr select").each ->
    item_index = parseInt(@id.split("_")[4])
    max_index = item_index  if max_index < item_index

  max_index
