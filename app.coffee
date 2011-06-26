config = require './config.coffee'
_ = require "underscore"
drews = require "drews-mixins"
formidable = require "formidable"
{wait, map, s} = _

log = (args...) -> console.log args... 


express = require('express')

drewsSignIn = (req, res, next) ->
  req.isSignedIn = () ->
    req.session.email isnt null
  next()


enableCORS = (req, res, next) ->
  req.header["Access-Control-Allow-Origin"] = "*"
  next()


app = module.exports = express.createServer()
app.configure () ->
  # app.use form
  #   keepExtensions: true
  #   uploadDir: "./public/files"
  app.use(express.bodyParser())
  app.use express.cookieParser()
  app.use express.session secret: "boom shaka laka"
  app.use(express.methodOverride())
  app.use(app.router)
  app.use(express.static(__dirname + '/public'))
  app.use drewsSignIn
  app.use enableCORS

app.configure 'development', () ->
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true })) 

app.configure 'production', () ->
  app.use(express.errorHandler()) 


pg = (p, f) ->
  app.post p, f
  app.get p, f


# Routes

app.get "/drew", (req, res) ->
  res.send "aguzate, hazte valer"


app.post "/", (req, res) ->
  form = new formidable.IncomingForm()
  form.keepExtensions = true
  form.uploadDir = "./public/files"
  # https://github.com/visionmedia/connect-form/pull/9/files
  # add multiples to the node-formidable parse method
  files = []
  form.on "file", (field, file) ->
    files.push file
  form.on "end", () ->
    res.send files
  form.parse(req)

      
        
        
      #res.send map files.files, (file) -> "http://filebox.drewl.us#{s file.path, 0, "public".length}"
      #res.send [fields, files]


pg "/p", (req, res) ->
  req.session.p = "gotta"
  res.send "...."

pg "/whoami", (req, res) ->
  res.send req.session
  


exports.app = app

if (!module.parent) 
  app.listen config.server.port || 8008
  console.log("Express server listening on port %d", app.address().port)

