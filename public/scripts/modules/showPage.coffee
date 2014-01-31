paddingTopMobile = 20
paddingTopLaptop = 130


makeBodyClassName = (pageName) ->
  'show-' + (pageName || rootPageName)


# this should be a parameter to the single-page-viewer module
rootPageName = 'home'



exports.dependsOn = ['window', 'document', 'loadScript', 'tools', '$', 'historyWrapper', 'unilytics', 'disqus']
exports.execute = ({ window, document, loadScript, tools, $, historyWrapper, unilytics, disqus }) ->
  
  win = window
  doc = document

  { memoize } = tools
  { pushState, onPopState, getCurrent } = historyWrapper (path) -> path.slice(1)

  doc.body.className = makeBodyClassName(getCurrent())

  loadScriptOnce = memoize(loadScript)

  setPaddingTop = (name, withAnimation) ->
    nodes = if name then $('.' + name) else $('div.content > div')

    if isMobileSized()
      nodes.css({ "padding-top": paddingTopMobile, opacity: 1 })
    else
      if withAnimation
        nodes.css({ "padding-top": paddingTopLaptop + 20, opacity: 0 }).animate({ "padding-top": paddingTopLaptop, opacity: 1 }, 400)
      else
        nodes.css({ "padding-top": paddingTopLaptop, opacity: 1 })

  window.addEventListener 'resize', ->
    setPaddingTop(null, false)

  showPageMarkup = (name) ->
    newClass = makeBodyClassName(name)
    oldClass = doc.body.className
    changed = newClass != oldClass

    doc.body.className = makeBodyClassName(name)

    setPaddingTop(name, changed && name)

    if name == 'speaker'
      loadScriptOnce('//speakerdeck.com/assets/embed.js')

    unilytics.page(name)

    pageElement = doc.getElementsByClassName(name)[0]
    if pageElement?.className.slice(0, 9) == 'blog-post'
      blogPostTitle = pageElement.querySelector('header h2')
      disqus.load(pageElement, name, blogPostTitle)

    scrollTo({ y: 0, animate: false })

  isMobileSized = ->
    win.innerWidth <= 760

  setPage = (name = '') ->
    showPageMarkup(name)
    pushState(name)

  onPopState (path = '') ->
    showPageMarkup(path)
  
  
  (name) -> setPage(name)
