(function() {
  eachArray(files, function(file) {
    var formData, reader, xhr;
    formData = new FormData;
    formData.append("name", file.name);
    formData.append("size", file.size);
    formData.append("type", file.type);
    formData.append("file", file);
    reader = new FileReader();
    xhr = new XMLHttpRequest();
    xhr.open("POST", "/pictures");
    xhr.onload = function(e) {
      return cb(null);
    };
    xhr.onerror = function(e) {
      return cb(e);
    };
    return xhr.send(formData);
  });
}).call(this);
