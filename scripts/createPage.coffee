opra = require 'opra'

exports.build = (page, callback) ->
  opra.build 'public/source.html', { compress: true }, (err, result) ->
    return callback(err) if err?

    name = page.slice(1) || 'home'
    moddedResult = result.replace(/<body[^>]*>/, '<body class="show-' + name + '">')
    callback(null, moddedResult)

exports.build404 = (callback) ->
  opra.build('public/404.html', { compress: true }, callback)

exports.pages = ['/', '/coder', '/train', '/recruit', '/architect', '/duediligence', '/speaker', '/about', '/blog', '/blog-post']
