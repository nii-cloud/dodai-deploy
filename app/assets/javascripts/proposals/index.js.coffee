start_polling = (state_span, proposal_id) ->
  $("#processing_img_" + proposal_id).show()

  $.timer 10000, (timer) ->
    $.ajax
      url: "/proposals/" + proposal_id + ".json"
      dataType: "json"
      data: {}
      async: false
      success: (data) ->
        state_span.html data.proposal.state
        unless data.proposal.state.match(/ing/)
          timer.stop()
          $("#processing_img_" + proposal_id).hide()
          window.location = ""


$ ->
  $(".state_span").each ->
    state_span = $(this)
    proposal_id = state_span.parent().parent().find(".proposal_id_td").html()
    start_polling state_span, proposal_id if state_span.html().match(/ing/)
