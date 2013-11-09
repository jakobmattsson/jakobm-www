connect = require 'connect'

originalLookup = connect.mime.lookup.bind(connect.mime)

connect.mime.lookup = (file) ->
  hasExtension = file.split('/').slice(-1)[0].indexOf('.') != -1
  if hasExtension
    originalLookup.call(this, file)
  else
    'text/html'

app = connect()
app.use connect.static(__dirname + '/../tmp/output')
app.listen(8282)

console.log "Listening to 8282..."
