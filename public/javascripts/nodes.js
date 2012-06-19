$(function() {
  $("#node_name").change(function() {
    set_node_name($(this));
  });

  set_node_name($("#node_name"));
});

function set_node_name(name_sel) {
  var current_name = name_sel.val();
  $.each(node_candidates, function() {
    if(this.name == current_name) {
      $("#node_ip").val(this.ip);
      return false;
    }
  });
}
