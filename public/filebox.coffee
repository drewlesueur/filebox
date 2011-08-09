# https://developer.mozilla.org/En/Using_XMLHttpRequest 
#TODO: implement ajax something like this
define "filebox", ->
  _ = require "underscore"
  drews = require "drews-mixins"
  require "nimble"
  $ = require "jquery"  
  {"on":bind, trigger, s, log, eachArray} = _
  FileBox = (options={}) ->
    _.extend options,
      color: "blue"
      backgroundColor: "yellow"
    self = {}
    form = $ """
        <form id="file-form" enctype="multipart-form"  method="POST" action="files">
        <input type="file" id="files" name="files" multiple/>
        </form>
    """
    form.bind "change", () ->
      files = form.find("#files")[0].files
      trigger self, "filesready", files

    bars = $ """
      <div class="progress-bar-wrapper"></div>
    """

    self.getEl = () ->
      form

    self.getProgressBars = () ->
      bars

    bind self, "filesready", (files) ->
      log "here are the fiels" 
      eachArray files, (file) ->
        bar = $ """
          <div style="border: 1px solid black; width:50px; height: 10px; margin: 0; padding: 0; background-color: #{options.backgroundColor}" class="progress-bar">
            <div style="height: 10px; width: 0px; margin: 0; padding: 0; background-color: #{options.color};" class="progress"></div>
          </div>
        """
        bar.appendTo bars

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
          res = JSON.parse e.currentTarget.responseText
          trigger self, "uploaded", res
        xhr.upload.onprogress = (e) ->
          console.log e
          progress =  e.position / e.totalSize
          width = bar.width()
          console.log "the width is #{width}"
          bar.find(".progress").css "width", "#{width * progress}px"
          
          console.log "there are progress"
          console.log progress
          trigger self, "progress", progress
        xhr.send formData
    self
