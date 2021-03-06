fs = require 'fs'
path = require 'path'
slugify = require 'slugify'
hljs = require 'highlight.js'
marked = require 'marked'
async = require 'async'
XDate = require 'xdate'
mkdirp = require 'mkdirp'
glob = require 'glob'
_ = require 'underscore'

blogRoot = 'public/blog-posts'

hardSlugify = (text) ->
  slugify(text || '').match(/[a-zA-Z0-9\- ]*/gi).join('').split(' ').join('-').toLowerCase()
  


runMarked = (code, callback) ->
  marked code, {
    highlight: (code, lang) ->
      if lang
        hljs.highlightAuto(lang, code).value
      else
        hljs.highlightAuto(code).value
  }, callback

shortDateFormat = (date) ->
  iso = new Date(date).toISOString()
  iso.slice(2, 4) + iso.slice(5, 7) + iso.slice(8, 10)


blogPostToUrl = (post) ->
  title = post.split(' ').slice(1).join(' ')
  url = '/' + hardSlugify(title)


getBlogPosts = ->
  fs.readdirSync(blogRoot).filter (name) ->
    fs.lstatSync(path.join(blogRoot, name)).isDirectory()


indentLines = (html, indent) ->
  spaces = _(indent).times((x) -> '  ').join('')
  html.split('\n').map((x) -> '\n' + spaces + x).join('')


insertBlogPosts = (data, callback) ->
  blogEnd = new RegExp('<span class="content-banner">&nbsp;</span>\\s*</div>\\s*</div>\\s*<div class="fallback">')
  ind = data.match(blogEnd).index
  before = data.slice(0, ind)
  after = data.slice(ind)

  posts = getBlogPosts()

  async.map posts, (post, callback) ->
    date = post.split(' ')[0]
    title = post.split(' ').slice(1).join(' ')
    postFile = path.join(blogRoot, post, 'post.md')
    postMarkdown = fs.readFileSync(postFile, 'utf8') || ''

    runMarked postMarkdown, propagate callback, (postContent) ->
      callback null, """
        <div class="blog-post #{hardSlugify(title)}">
          <h1>
            <span class="breadcrumb">
              <a href="/">Home</a>
              <span> / </span>
            </span>
            <span>
              <a href="/blog">Blog</a>
              <span> / </span>
            </span>
            <span>#{title}</span>
          </h1>
          <article>
            <header>
              <span class="post-date">#{new XDate(date).toString('d MMM yyyy')}</span>
              <h2>#{title}</h2>
            </header>
            <section>
              #{postContent}
            </section>
          </article>
        </div>
      """
  , propagate callback, (mid) ->
    callback(null, before.trim() + '\n\n' + mid.reverse().join('\n\n') + '\n\n' + '  ' + after)



insertBlogList = (data, callback) ->
  blogStart = new RegExp('<span>Blog</span>\\s*</h1>')
  ind = data.match(blogStart).index + data.match(blogStart)[0].length
  before = data.slice(0, ind)
  after = data.slice(ind)

  posts = getBlogPosts()

  async.map posts, (post, callback) ->
    date = post.split(' ')[0]
    title = post.split(' ').slice(1).join(' ')
    summaryFile = path.join(blogRoot, post, 'summary.md')
    summaryMarkdown = fs.readFileSync(summaryFile, 'utf8') || ''
    url = blogPostToUrl(post)

    runMarked summaryMarkdown, propagate callback, (summary) ->
      callback null, """
        <article>
          <header>
            <span class="post-date">#{date}</span>
            <h2><a href="#{url}">#{title}</a></h2>
          </header>
          <section>
            #{summary.trim()}
          </section>
        </article>
      """
  , propagate callback, (mid) ->
    lines = indentLines(mid.reverse().join('\n'), 3)
    callback(null, before + lines + after)

extendCss = ->
  styleFile = 'tmp/output/.code/styles.css'
  styles = fs.readFileSync(styleFile, 'utf8')

  pages().map((x) -> x.slice(1)).filter(Boolean).forEach (page) ->
    styles += "body.show-#{page} > div.outer-wrapper > div.content > div.#{page} { display: block; }\n"

  fs.writeFileSync(styleFile, styles, 'utf8')



propagate = (onErr, onSucc) -> (err, rest...) -> if err? then onErr(err) else onSucc(rest...)

build = (source, callback) ->
  fs.readFile source, 'utf8', propagate callback, (data) ->
    extendCss()
    insertBlogList data, propagate callback, (newData) ->
      insertBlogPosts(newData, callback)
    

pages = ->
  base = ['/', '/coder', '/train', '/recruit', '/architect', '/duediligence', '/speaker', '/about', '/blog']
  base.concat getBlogPosts().map(blogPostToUrl)




writeFilep = (filename, data, callback) ->
  dir = path.dirname(filename)
  mkdirp dir, propagate callback, ->
    fs.writeFile(filename, data, callback)




deleteFiles = (pattern, callback) ->
  glob pattern, {}, propagate callback, (files) ->
    files.forEach (f) ->
      fs.unlinkSync(f)
    callback()


run = (callback) ->
  build 'tmp/output/source.html', propagate callback, (result) ->
    async.parallel [
      (callback) ->
        fs.unlinkSync('tmp/output/source.html')
        callback()
    ,
      (callback) -> deleteFiles('tmp/output/blog-posts/**/*.md', callback)
    ,
      (callback) -> deleteFiles('tmp/output/**/.DS_Store', callback)
    ,
      (callback) ->
        async.forEachSeries pages(), (page, callback) ->
          name = page.slice(1) || 'home'
          moddedResult = result.replace(/<body[^>]*>/, '<body class="show-' + name + '">')
          writeFilep("tmp/output/#{name}", moddedResult, callback)
        , callback
    ]


run (err) ->
  console.log(err) if err?
