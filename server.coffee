opra = require 'opra'
express = require 'express'

app = express()
app.use express.static(__dirname + '/public')

pages = ['/', '/coder', '/train', '/recruit', '/architect', '/duediligence', '/speaker', '/about', '/blog', '/blog-post']

pages.forEach (page) ->
  app.get page, (req, res, next) ->
    opra.build 'public/source.html', { inline: true }, (err, result) ->
      if err
        console.log("OPRA ERROR", err)
        next()
        return

      name = page.slice(1) || 'start'
      moddedResult = result.replace(/<body[^>]*>/, '<body class="show-' + name + '">')
      res.setHeader('Content-Type', 'text/html')
      res.setHeader('Content-Length', Buffer.byteLength(moddedResult))
      res.end(moddedResult)

app.get '*', (req, res, next) ->
  res.end('404')

app.listen(8200)
console.log "Running server on port 8200..."
