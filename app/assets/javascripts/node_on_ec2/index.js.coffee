start_polling = (state_span, instance_id) ->
  $("#processing_img_" + instance_id + "_" + state_span.html()).show()
  $.timer 10000, (timer) ->
    if state_span.html().match(/running|available|deleted|server/)
      timer.stop()
      $("#processing_img_" + instance_id + "_" + state_span.html()).hide()
    window.location = ""


$ ->
  $(".state_span").each ->
    state_span = $(this)
    instance_id = state_span.parent().parent().find(".instance_id_td").html()
    start_polling state_span, instance_id unless state_span.html().match(/running|available|deleted|server/)
