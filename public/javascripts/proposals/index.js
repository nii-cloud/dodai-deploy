$(function() {
  $(".state_span").each(function() {
    var state_span = $(this);
    var proposal_id = state_span.parent().parent().find(".proposal_id_td").html();
    if (state_span.html().match(/ing/)) {
      start_polling(state_span, proposal_id);
    }
  });
});

function start_polling(state_span, proposal_id) {
	$("#processing_img_" + proposal_id).show();
  $.timer(10000, function (timer) {
		$.ajax({
			url: "/proposals/" + proposal_id + ".json",
			dataType: 'json',
			data: {},
			async: false,
			success: function(data) {
				state_span.html(data.proposal.state);
				if (!data.proposal.state.match(/ing/)) {
					timer.stop();
					$("#processing_img_" + proposal_id).hide();
          location = "";
				}
			}
		});
	});
}
