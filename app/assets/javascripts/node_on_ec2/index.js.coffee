start_polling =  ->
  $.timer 5000, (timer) ->
    $.get window.location.href + ".json", (instances) ->
      processing = false
      $.each instances,  ->
        console.debug this

        instance_id = this.aws_instance_id
        instance_state = this.aws_state
        node_state = this.node_state
        ip = this.private_ip_address
        name = this.private_dns_name

        return if $("#instance_state_" + instance_id).size() == 0

        $("#instance_state_" + instance_id).html(instance_state)
        if instance_state.match /running|terminated/
          $("#processing_img_instance_" + instance_id).hide()
        else
          processing = true
          $("#processing_img_instance_" + instance_id).show()
        
        $("#node_state_" + instance_id).html(node_state)
        if node_state.match /available|deleted/
          $("#processing_img_node_" + instance_id).hide()
        else
          processing = true
          $("#processing_img_node_" + instance_id).show()

        $("#ip_" + instance_id).html(ip)
        $("#name_" + instance_id).html(name)

      console.debug processing
      timer.stop() unless processing


$ ->
  processing = false
  $(".instance_state_span").each ->
    state_span = $(this)
    unless state_span.html().match /running|terminated/
      instance_id = state_span.parent().parent().find(".instance_id_td").html()
      $("#processing_img_instance_" + instance_id).show()
      processing = true

  $(".node_state_span").each ->
    state_span = $(this)
    unless state_span.html().match /available|deleted/
      instance_id = state_span.parent().parent().find(".instance_id_td").html()
      $("#processing_img_node_" + instance_id).show()
      processing = true

  start_polling() if processing
