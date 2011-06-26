#TODO: implement ajax something like this
define "filebox", ->
  _ = require "underscore"
  drews = require "drews-mixins"
  nimble = require "nimble"
  $ = require "jquery"  
  {"on":bind, trigger, s, log, eachArray} = _
  self = {}
  self.getEl = () ->
    form = $ """
      <form id="file-form" enctype="multipart-form"  method="POST" action="files">
      <input type="file" id="files" name="files" multiple/>
      </form>
    """
    form.bind "change", () ->
      files = form.find("#files")[0].files
      trigger self, "filesready", files
    form
  bind self, "filesready", (files) ->
    log "here are the fiels" 
    eachArray files, (file) ->
      log "the file is"
      log file
      formData = new FormData
      formData.append "name", file.name
      formData.append "size", file.size
      formData.append "type", file.type
      formData.append "file", file
      reader = new FileReader()
      xhr = new XMLHttpRequest()
      xhr.open("POST", "http://filebox.drewl.us/");
      xhr.onload = (e) ->
        console.log "done!"
        res = JSON.stringify e.currentTarget.responseText
        trigger self, "uploaded", res
      xhr.send formData
  self
  



