#This is example usage
_ = require "underscore"
$ = require "jquery"
drews = require "drews-mixins"
filebox = require "filebox"
$ ->
  {"on": bind, log} = _
  fileForm = filebox.getEl()
  log fileForm
  $(document.body).append fileForm
  bind filebox, "uploaded", (urls) ->
    each urls, (url) ->
      $(document.body).append $ """
        <a href="#{url}">file</a>
      """
  
  

