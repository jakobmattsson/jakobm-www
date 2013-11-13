fs = require 'fs'
connect = require 'connect'

port = 8282

originalLookup = connect.mime.lookup.bind(connect.mime)

connect.mime.lookup = (file) ->
  hasExtension = file.split('/').slice(-1)[0].indexOf('.') != -1
  if hasExtension
    originalLookup.call(this, file)
  else
    'text/html'

app = connect()

app.use connect.static(__dirname + '/../tmp/output')

app.use (req, res, next) ->
  if req.url == '/'
    res.end(fs.readFileSync(__dirname + '/../tmp/output/home'))
  else
    next()

app.use (req, res) ->
  res.statusCode = 404
  res.end(fs.readFileSync(__dirname + '/../tmp/output/404.html'))

app.listen(port)

console.log "Listening to port #{port}..."
