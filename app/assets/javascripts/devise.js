$(function() {
  $("#center-div").dialog({
    modal: true,
    resizable: false,
    closeOnEscape: false,
    draggable: false,
    open: function(event, ui) {
      $(".ui-dialog-titlebar-close").hide();
      var title = $(this).find("h2").remove().html();
      $(this).dialog("option", "title", title);
      $(".ui-widget-overlay").offset({top: -2, left: -2});
    }
  });
});
