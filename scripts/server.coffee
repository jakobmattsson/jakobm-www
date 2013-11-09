express = require 'express'
createPage = require './createPage'

app = express()
app.use express.static(__dirname + '/../public')

createPage.pages.forEach (page) ->
  app.get page, (req, res, next) ->
    createPage.build page, (err, result) ->
      res.setHeader('Content-Type', 'text/html')
      res.setHeader('Content-Length', Buffer.byteLength(result))
      res.end(result)

app.get '*', (req, res, next) ->
  res.end('404')

app.listen(8200)
console.log "Running server on port 8200..."
