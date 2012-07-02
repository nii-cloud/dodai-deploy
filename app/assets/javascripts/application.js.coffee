String::replaceAll = (org, dest) ->
  @split(org).join dest

unless window["console"]
  window.console =
    info: ->
    log: ->
    warn: ->
    error: ->
    debug: ->


$ ->
  $("body").height $(window).height()
  $("body").layout
    closable: false
    resizable: false
    slidable: false

  $(":text").attr "size", 60
  $("body").show()
