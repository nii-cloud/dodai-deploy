$(function() {
  $("textarea").val("");

  $(":button").attr("disabled", false).click(function() {
    do_click_exec_btn(this);
  });

  $("#accordion").accordion({collapsible: true, autoHeight: false});

  $("#software_sel").change(function() {
    create_params($(this).val());
  });

  var proposal_id = "";
  $("#update_proposal_parameters_table").find("input:first").focusout(function() {
    if (proposal_id == $(this).val()) {
      return
    }

    proposal_id = $(this).val();
    create_update_params(proposal_id);
  });

  $("#update_proposal_parameters_table").find("tr:eq(1)").html('<td colspan=2><textarea></textarea></td>');

  create_params($("#software_sel").val());
});

function create_update_params(proposal_id) {
  $.getJSON("/proposals/" + proposal_id + ".json", function(proposal) {
    create_update_html_str(proposal.proposal);
  });
}

function create_update_html_str(proposal) {
  var params = {};
  params["proposal[name]"] = proposal.name;

  $.each(proposal.node_configs, function(index, node_config) {
    params["proposal[node_configs_attributes][" + index + "][component_name]"] = node_config.component.name;
    params["proposal[node_configs_attributes][" + index + "][node_name]"] = node_config.node.name;
    params["proposal[node_configs_attributes][" + index + "][id]"] = node_config.id;
  });

  $.each(proposal.config_items, function(index, config_item) {
    params["proposal[config_items_attributes][" + index + "][name]"] = config_item.config_item_default.name;
    params["proposal[config_items_attributes][" + index + "][value]"] = config_item.value;
    params["proposal[config_items_attributes][" + index + "][id]"] = config_item.id;
  });

  $.each(proposal.software_configs, function(index, software_config) {
    params["proposal[software_configs_attributes][" + index + "][path]"] = software_config.software_config_default.path;
    params["proposal[software_configs_attributes][" + index + "][content]"] = software_config.content;
    params["proposal[software_configs_attributes][" + index + "][id]"] = software_config.id;
  });

  $.each(proposal.component_configs, function(index, component_config) {
      params["proposal[component_configs_attributes][" + index + "][component_name]"] = component_config.component.name;
      params["proposal[component_configs_attributes][" + index + "][path]"] = component_config.component_config_default.path;
      params["proposal[component_configs_attributes][" + index + "][content]"] = component_config.content;
      params["proposal[component_configs_attributes][" + index + "][id]"] = component_config.id;
  });

  var json_str = JSON.stringify(params, null, "    ");
  var line_number = json_str.match(/\n/g).length;
  html_str = '<td colspan=2><textarea rows=' + (line_number + 10)  + '>' + json_str  +   '</textarea></td>';

  $("#update_proposal_parameters_table").find("tr:eq(1)").html(html_str);  
}

function create_params(software_id) {
  $.getJSON("/nodes.json", function(nodes) {
    $.getJSON("/softwares/" + software_id + ".json", function(data) {
      create_html_str(data.software, nodes);
    });
  });
}

function create_html_str(software, nodes) {
  var node_name = nodes.length > 0 ? nodes[0].node.name : "";
  var params = {};
  params["proposal[name]"] = "";
  params["proposal[software_desc]"] = software.desc;
  $.each(software.components, function(index, component) {
    params["proposal[node_configs_attributes][" + index + "][component_name]"] = component.name;
    params["proposal[node_configs_attributes][" + index + "][node_name]"] = node_name;
  });

  $.each(software.config_item_defaults, function(index, config_item_default) {
    params["proposal[config_items_attributes][" + index + "][name]"] = config_item_default.name;
    params["proposal[config_items_attributes][" + index + "][value]"] = config_item_default.value;
  });

  $.each(software.software_config_defaults, function(index, software_config_default) {
    params["proposal[software_configs_attributes][" + index + "][path]"] = software_config_default.path;
    params["proposal[software_configs_attributes][" + index + "][content]"] = this.content;
  });

  var config_index = 0;
  $.each(software.components, function(index, component) {
    $.each(component.component_config_defaults, function() {
      params["proposal[component_configs_attributes][" + config_index + "][component_name]"] = component.name;
      params["proposal[component_configs_attributes][" + config_index + "][path]"] = this.path;
      params["proposal[component_configs_attributes][" + config_index + "][content]"] = this.content;
      config_index++;
    });
  });

  var json_str = JSON.stringify(params, null, "    ");
  var line_number = json_str.match(/\n/g).length;
  html_str = '<tr><td><textarea rows=' + (line_number + 10)  + '>' + json_str  +   '</textarea></td></tr>';

  $("#create_proposal_parameters_table").find("tbody").html(html_str);
}

function do_click_exec_btn(btn) {
  var action = btn.id.substr(0, btn.id.length - 4);
  var method = $("#" + action + "_method_td").html();
  var url =  $("#" + action + "_url_td").html();
  var parameter_trs = $("#" + action + "_parameters_table").find("tr");

  if (!validate_parameters(parameter_trs)) {
    return
  }

  $(":button").attr("disabled", true);
  $(btn).next().show();

  var data = {};
  if (action == "create_proposal" || action == "update_proposal") {
    data = $.parseJSON($("#" + action + "_parameters_table").find("textarea").val());
  } 

  parameter_trs.each(function() {
    if (!$(this).find("th").length)
      return

    name = $(this).find("th").html();
    value = $(this).find(":text").val();
    data[name] = value;

    url = url.replace(":" + name, value);
  });
  
  $.ajax({
    url: url,
    type: method,
    data: data,
    dataType: "text",
    success: function(data) {
      var match_result = data.match(/\n/g);
      var len = 0;
      if(match_result) {
				len = match_result.length; 
      }
      $("#" + action + "_result_textarea").attr("rows", len + 1).val(data);
      if(data != "") {
        var obj;
        eval("obj=" + data);
        if (obj.errors) {
          alert("Failed.");
          return;
        }
      }
      alert("Succeeded.");
    },
    error: function(data) {
      $("#" + action + "_result_textarea").attr("rows", 1).val("");
      alert("Error occurred!!!");
    },
    complete: function() {
      $(":button").attr("disabled", false);
      $(btn).next().hide();
    }
  });
}

function validate_parameters(parameter_trs) {
  var succeeded = true
  parameter_trs.each(function() {
    name = $(this).find("th").html();
    value = $(this).find(":text").val();
    if ("" == value) {
      alert("Parameter '" + name + "' cannot be empty.");
      succeeded = false;
      return false;
    }
  });
  return succeeded;
}
