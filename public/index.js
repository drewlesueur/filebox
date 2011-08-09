(function() {
  var $, FileBox, drews, _;
  _ = require("underscore");
  $ = require("jquery");
  drews = require("drews-mixins");
  FileBox = require("filebox");
  $(function() {
    var bind, each, fileForm, filebox, log, progressBar;
    bind = _["on"], log = _.log, each = _.each;
    filebox = FileBox();
    fileForm = filebox.getEl();
    progressBar = filebox.getProgressBars();
    log(fileForm);
    $(document.body).append(fileForm).append(progressBar);
    bind(filebox, "uploaded", function(urls) {
      log("the urls are ");
      log(urls);
      return each(urls, function(url) {
        return $(document.body).append($("<a href=\"" + url + "\" target=\"_blank\">file</a>"));
      });
    });
    return bind(filebox, "progress", function(progress) {});
  });
}).call(this);
