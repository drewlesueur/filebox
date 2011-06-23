config = require './config.coffee'
_ = require "underscore"
require("drews-mixins") _
form = require "connect-form"

{wait} = _

log = (args...) -> console.log args... 


express = require('express')

drewsSignIn = (req, res, next) ->
  req.isSignedIn = () ->
    req.session.email isnt null
  next()

app = module.exports = express.createServer()
app.configure () ->
  app.use form
    keepExtensions: true
    uploadDir: "./pics"
  app.use(express.bodyParser())
  app.use express.cookieParser()
  app.use express.session secret: "boom shaka laka"
  app.use(express.methodOverride())
  app.use(app.router)
  app.use(express.static(__dirname + '/public'))
  app.use drewsSignIn

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
  log "old trying to uplaod a pictures"
  if not req.form
    res.send "you need to do mulitpart/form-data"
  else
    req.form.complete (err, fields, files) ->
      res.send JSON.stringify files


pg "/p", (req, res) ->
  req.session.p = "gotta"
  res.send "...."

pg "/whoami", (req, res) ->
  res.send req.session
  


exports.app = app

if (!module.parent) 
  app.listen config.server.port || 8008
  console.log("Express server listening on port %d", app.address().port)

