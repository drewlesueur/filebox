#TODO: implement ajax something like this


eachArray files, (file) ->
  formData = new FormData
  formData.append "name", file.name
  #formData.append "name[0]", file.name
  formData.append "size", file.size
  formData.append "type", file.type
  formData.append "file", file
  reader = new FileReader()
  xhr = new XMLHttpRequest()
  xhr.open("POST", "/pictures");
  #xhr.onload
  #xhr.upload.onload = (e) ->
  #xhr.onreadystatechange = (e) ->
  #  if xhr.readyState is 4 and xhr.status is 200
  xhr.onload = (e) ->
    cb null
  xhr.onerror = (e) -> cb e
  xhr.send formData 
