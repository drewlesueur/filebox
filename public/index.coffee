#This is example usage
_ = require "underscore"
$ = require "jquery"
drews = require "drews-mixins"
filebox = require "filebox"
$ ->
  {"on": bind, log, each} = _
  fileForm = filebox.getEl()
  log fileForm
  $(document.body).append fileForm
  bind filebox, "uploaded", (urls) ->
    log "the urls are "
    log urls
    return
    each urls, (url) ->
      $(document.body).append $ """
        <a href="#{url}">file</a>
      """
  
  

