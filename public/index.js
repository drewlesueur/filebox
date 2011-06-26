(function() {
  var $, drews, filebox, _;
  _ = require("underscore");
  $ = require("jquery");
  drews = require("drews-mixins");
  filebox = require("filebox");
  $(function() {
    var bind, fileForm, log;
    bind = _["on"], log = _.log;
    fileForm = filebox.getEl();
    log(fileForm);
    $(document.body).append(fileForm);
    return bind(filebox, "uploaded", function(urls) {
      return each(urls, function(url) {
        return $(document.body).append($("<a href=\"" + url + "\">file</a>"));
      });
    });
  });
}).call(this);
