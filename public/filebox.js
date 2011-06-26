(function() {
  define("filebox", function() {
    var $, bind, drews, eachArray, log, nimble, s, self, trigger, _;
    _ = require("underscore");
    drews = require("drews-mixins");
    nimble = require("nimble");
    $ = require("jquery");
    bind = _["on"], trigger = _.trigger, s = _.s, log = _.log, eachArray = _.eachArray;
    self = {};
    self.getEl = function() {
      var form;
      form = $("<form id=\"file-form\" enctype=\"multipart-form\"  method=\"POST\" action=\"files\">\n<input type=\"file\" id=\"files\" name=\"files\" multiple/>\n</form>");
      form.bind("change", function() {
        var files;
        files = form.find("#files")[0].files;
        return trigger(self, "filesready", files);
      });
      return form;
    };
    bind(self, "filesready", function(files) {
      log("here are the fiels");
      return eachArray(files, function(file) {
        var formData, reader, xhr;
        log("the file is");
        log(file);
        formData = new FormData;
        formData.append("name", file.name);
        formData.append("size", file.size);
        formData.append("type", file.type);
        formData.append("file", file);
        reader = new FileReader();
        xhr = new XMLHttpRequest();
        xhr.open("POST", "http://filebox.drewl.us/");
        xhr.onload = function(e) {
          var res;
          console.log("done!");
          res = JSON.stringify(e.currentTarget.responseText);
          return trigger(self, "uploaded", res);
        };
        return xhr.send(formData);
      });
    });
    return self;
  });
}).call(this);
