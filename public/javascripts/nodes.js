$(function() {
  $("#node_ip").change(function() {
    set_node_name($(this));
  });

  set_node_name($("#node_ip"));
});

function set_node_name(ip_sel) {
  var current_ip = ip_sel.val();
  $.each(node_candidates, function() {
    if(this.ip == current_ip) {
      $("#node_name").val(this.name);
      return false;
    }
  });
}
