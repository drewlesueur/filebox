config = require './config.coffee'
_ = require "underscore"
nimble = require "nimble"
_.mixin nimble
drews = require "drews-mixins"
formidable = require "formidable"
crypto = require "crypto"
fs = require "fs"
util = require "util"

{wait, map, s, log} = _
log _.series



express = require('express')

drewsSignIn = (req, res, next) ->
  req.isSignedIn = () ->
    req.session.email isnt null
  next()


enableCORS = (req, res, next) ->
  res.setHeader "Access-Control-Allow-Origin", "*"
  next()


app = module.exports = express.createServer()
app.configure () ->
  app.use enableCORS
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

moveFile = (source, dest, cb) ->
 inStream = fs.createReadStream(source)
 outStream = fs.createWriteStream(dest)
 util.pump inStream, outStream, (err) ->
   if err then return cb err 
   fs.unlink source, (err) ->
     if err then return cb err
     cb null, dest


createFileHash = (file, cb) ->
  shasum = crypto.createHash 'sha1'
  stream = fs.ReadStream file
  stream.on 'data', (data) -> shasum.update data
  stream.on 'error', (err) -> cb err
  stream.on 'end', () ->
    hash = shasum.digest 'hex'
    cb null, hash

  


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
    # you could use nimble.series if you created a function for every on
    # or you could use drews.doneMaker
    map files, (file, cb) ->
      extension = s(file.path.split("."), 1).join "."
      createFileHash file.path, (err, hash) ->
        fileName = "#{hash}.#{extension}"
        moveFile file.path, "./public/files/#{fileName}", (err) ->
          cb err, "http://filebox.drewl.us/files/#{fileName}"
    , (err, results) ->
      res.send results
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

