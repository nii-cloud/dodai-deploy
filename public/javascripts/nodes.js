function set_node_os(name_sel) {
  current_name = name_sel.val();
  $.each(node_candidates, function() {
    if (current_name == this.hostname) {
      $("#node_os").val(this.os);
      $("#node_os_version").val(this.os_version);
      return false;
    }
  });
}


$(function() {
  $("#node_name").change(function() {
    set_node_os($(this));
  });

  set_node_os($("#node_name"));
});
