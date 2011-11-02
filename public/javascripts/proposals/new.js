$(function() {
  $("#proposal_software_id").change(function() {
    document.location = '?software=' + this.value;
  })

  init_add_delete_buttons();
})
