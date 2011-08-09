#This is example usage
_ = require "underscore"
$ = require "jquery"
drews = require "drews-mixins"
FileBox = require "filebox"
$ ->
  {"on": bind, log, each} = _
  filebox = FileBox()
  fileForm = filebox.getEl()
  progressBar = filebox.getProgressBars()
  log fileForm
  $(document.body).append(fileForm).append progressBar
  bind filebox, "uploaded", (urls) ->
    log "the urls are "
    log urls
    each urls, (url) ->
      $(document.body).append $ """
        <a href="#{url}" target="_blank">file</a>
      """
  bind filebox, "progress", (progress) ->
    
  
  

