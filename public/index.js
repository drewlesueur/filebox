(function() {
  var $, drews, filebox, _;
  _ = require("underscore");
  $ = require("jquery");
  drews = require("drews-mixins");
  filebox = require("filebox");
  $(function() {
    var bind, each, fileForm, log;
    bind = _["on"], log = _.log, each = _.each;
    fileForm = filebox.getEl();
    log(fileForm);
    $(document.body).append(fileForm);
    return bind(filebox, "uploaded", function(urls) {
      log("the urls are ");
      log(urls);
      return;
      return each(urls, function(url) {
        return $(document.body).append($("<a href=\"" + url + "\">file</a>"));
      });
    });
  });
}).call(this);
