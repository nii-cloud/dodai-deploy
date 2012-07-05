function add_node_config(add_btn) {
  var node_config_table = add_btn.parent().parent().find(".node_config_table");
  var node_config_tr = node_config_table.find(".node_config_tr:last")
  var node_config_number = node_config_table.find(".node_config_tr").size(); 

  node_size = node_config_tr.find("option").size();
  console.debug("Node size: " + node_size);
  if(node_config_number >= node_size) {
    alert("The node can't be added because the number of nodes added is larger than or equals to total number of nodes.");
    return;
  }

  var new_node_config_tr = node_config_tr.clone();
  var index = max_node_config_index_number() + 1;

  old_index = new_node_config_tr.find("select").attr("id").split("_")[4];
  html = new_node_config_tr.html();
  console.debug(html);
  html = html.replaceAll("_" + old_index, "_" + index);
  html = html.replaceAll("[" + old_index, "[" + index);
  html = html.replace("installed", "init");

  var selected_index = node_config_tr.find("select").prop("selectedIndex");

  console.debug(html);
  new_node_config_tr.html(html);
  node_config_tr.parent().append(new_node_config_tr);
  var found_selected = false;
  console.debug(selected_index);
  node_config_tr.parent().find(".node_config_tr:last").find("select").prop("selectedIndex", 
    Math.min(selected_index + 1, node_size - 1));
}

function delete_node_config(delete_btn) {
  if (delete_btn.parentsUntil("table").find(".node_config_tr").size() <= 1) {
    alert("At least one node should be left.");
    return;
  }
 
  delete_btn.parent().parent().next(":hidden").remove();
  delete_btn.parent().parent().remove(); 
}

function init_add_delete_buttons() {
  $(".add_btn").live("click", function() {
    add_node_config($(this));
  });

  $(".delete_btn").live("click", function() {
    delete_node_config($(this));
  });
}

function max_node_config_index_number() {
  var max_index = 0;
  $(".node_config_tr select").each(function() {
    var item_index = parseInt(this.id.split("_")[4]);
    if (max_index < item_index) {
      max_index = item_index
    }
  });

  return max_index;
}
