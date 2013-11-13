fs = require 'fs'
hljs = require 'highlight.js'
marked = require 'marked'

code = fs.readFileSync('public/blog-posts/2013-10-29 I built this cool thing with JavaScript/post.md', 'utf8')

marked code, {
  highlight: (code, lang) ->
    console.log "HIGHLIGHT", code, lang
    if lang
      hljs.highlightAuto(lang, code).value
    else
      hljs.highlightAuto(code).value
}, (err, content) ->
  console.log err
  console.log content
