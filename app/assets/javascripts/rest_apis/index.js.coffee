create_update_params = (proposal_id) ->
  $.getJSON "/proposals/" + proposal_id + ".json", (proposal) ->
    create_update_html_str proposal.proposal

create_update_html_str = (proposal) ->
  params = {}
  params["proposal[name]"] = proposal.name
  $.each proposal.node_configs, (index, node_config) ->
    params["proposal[node_configs_attributes][" + index + "][component_name]"] = node_config.component.name
    params["proposal[node_configs_attributes][" + index + "][node_name]"] = node_config.node.name
    params["proposal[node_configs_attributes][" + index + "][id]"] = node_config.id

  $.each proposal.config_items, (index, config_item) ->
    params["proposal[config_items_attributes][" + index + "][name]"] = config_item.config_item_default.name
    params["proposal[config_items_attributes][" + index + "][value]"] = config_item.value
    params["proposal[config_items_attributes][" + index + "][id]"] = config_item.id

  $.each proposal.software_configs, (index, software_config) ->
    params["proposal[software_configs_attributes][" + index + "][path]"] = software_config.software_config_default.path
    params["proposal[software_configs_attributes][" + index + "][content]"] = software_config.content
    params["proposal[software_configs_attributes][" + index + "][id]"] = software_config.id

  $.each proposal.component_configs, (index, component_config) ->
    params["proposal[component_configs_attributes][" + index + "][component_name]"] = component_config.component.name
    params["proposal[component_configs_attributes][" + index + "][path]"] = component_config.component_config_default.path
    params["proposal[component_configs_attributes][" + index + "][content]"] = component_config.content
    params["proposal[component_configs_attributes][" + index + "][id]"] = component_config.id

  json_str = JSON.stringify(params, null, "    ")
  line_number = json_str.match(/\n/g).length
  html_str = "<td colspan=2><textarea rows=" + (line_number + 10) + ">" + json_str + "</textarea></td>"
  $("#update_proposal_parameters_table").find("tr:eq(1)").html html_str

create_params = (software_id) ->
  $.getJSON "/nodes.json", (nodes) ->
    $.getJSON "/softwares/" + software_id + ".json", (data) ->
      create_html_str data.software, nodes
      
create_html_str = (software, nodes) ->
  node_name = (if nodes.length > 0 then nodes[0].node.name else "")
  params = {}
  params["proposal[name]"] = ""
  params["proposal[software_desc]"] = software.desc
  $.each software.components, (index, component) ->
    params["proposal[node_configs_attributes][" + index + "][component_name]"] = component.name
    params["proposal[node_configs_attributes][" + index + "][node_name]"] = node_name

  $.each software.config_item_defaults, (index, config_item_default) ->
    params["proposal[config_items_attributes][" + index + "][name]"] = config_item_default.name
    params["proposal[config_items_attributes][" + index + "][value]"] = config_item_default.value

  $.each software.software_config_defaults, (index, software_config_default) ->
    params["proposal[software_configs_attributes][" + index + "][path]"] = software_config_default.path
    params["proposal[software_configs_attributes][" + index + "][content]"] = @content

  config_index = 0
  $.each software.components, (index, component) ->
    $.each component.component_config_defaults, ->
      params["proposal[component_configs_attributes][" + config_index + "][component_name]"] = component.name
      params["proposal[component_configs_attributes][" + config_index + "][path]"] = @path
      params["proposal[component_configs_attributes][" + config_index + "][content]"] = @content
      config_index++

  json_str = JSON.stringify(params, null, "    ")
  line_number = json_str.match(/\n/g).length
  html_str = "<tr><td><textarea rows=" + (line_number + 10) + ">" + json_str + "</textarea></td></tr>"
  $("#create_proposal_parameters_table").find("tbody").html html_str

do_click_exec_btn = (btn) ->
  action = btn.id.substr(0, btn.id.length - 4)
  method = $("#" + action + "_method_td").html()
  url = $("#" + action + "_url_td").html()
  parameter_trs = $("#" + action + "_parameters_table").find("tr")
  return  unless validate_parameters(parameter_trs)
  $(":button").attr "disabled", true
  $(btn).next().show()
  data = {}
  data = $.parseJSON($("#" + action + "_parameters_table").find("textarea").val())  if action is "create_proposal" or action is "update_proposal"
  parameter_trs.each ->
    return name = $(this).find("th").html()  unless $(this).find("th").length
    value = $(this).find(":text").val()
    data[name] = value
    url = url.replace(":" + name, value)

  $.ajax
    url: url
    type: method
    data: data
    dataType: "text"
    success: (data) ->
      match_result = data.match(/\n/g)
      len = 0
      len = match_result.length  if match_result
      $("#" + action + "_result_textarea").attr("rows", len + 1).val data
      unless data is ""
        obj = undefined
        eval "obj=" + data
        if obj.errors
          alert "Failed."
          return
      alert "Succeeded."

    error: (data) ->
      $("#" + action + "_result_textarea").attr("rows", 1).val ""
      alert "Error occurred!!!"

    complete: ->
      $(":button").attr "disabled", false
      $(btn).next().hide()

validate_parameters = (parameter_trs) ->
  succeeded = true
  parameter_trs.each ->
    name = $(this).find("th").html()
    value = $(this).find(":text").val()
    if "" is value
      alert "Parameter '" + name + "' cannot be empty."
      succeeded = false
      false

  succeeded


$ ->
  $("textarea").val ""
  $(":button").attr("disabled", false).click ->
    do_click_exec_btn this

  $("#accordion").accordion
    collapsible: true
    autoHeight: false

  $("#software_sel").change ->
    create_params $(this).val()

  proposal_id = ""
  $("#update_proposal_parameters_table").find("input:first").focusout ->
    return  if proposal_id is $(this).val()
    proposal_id = $(this).val()
    create_update_params proposal_id

  $("#update_proposal_parameters_table").find("tr:eq(1)").html "<td colspan=2><textarea></textarea></td>"
  create_params $("#software_sel").val()
