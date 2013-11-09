fs = require 'fs'
async = require 'async'
createPage = require './createPage'

async.parallel [
  #(callback) ->
  #  createPage.build404 (err, result) ->
  #    return callback(err) if err?
  #    fs.writeFile("tmp/output/404.html", result, callback)
  (callback) ->
    async.forEach createPage.pages, (page, callback) ->
      createPage.build page, (err, result) ->
        name = page.slice(1) || 'index.html'
        fs.writeFile("tmp/output/#{name}", result, callback)
    , callback
], (err) ->
  console.log(err) if err?
