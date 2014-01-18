makeBodyClassName = (pageName) ->
  'show-' + (pageName || rootPageName)


# this should be a parameter to the single-page-viewer module
rootPageName = 'home'




exports.execute = ({ window, document, loadScript, tools, $, historyWrapper, unilytics }) ->
  
  win = window
  doc = document

  toggleScrollButton = (showScrollButton) ->
    $('.scroll-to-top').toggle(showScrollButton)
  
  { memoize } = tools
  { pushState, onPopState, getCurrent } = historyWrapper (path) -> path.slice(1)

  doc.body.className = makeBodyClassName(getCurrent())

  loadScriptOnce = memoize(loadScript)

  showPageMarkup = (name) ->
    showScrollToTop = isMobileSized() && name != 'home' && name != ''
    toggleScrollButton(showScrollToTop)

    newClass = makeBodyClassName(name)
    oldClass = doc.body.className
    changed = newClass != oldClass

    doc.body.className = makeBodyClassName(name)

    if changed && name && !isMobileSized()
      $('.' + name).css({ "padding-top": 150, opacity: 0 }).animate({ "padding-top": 130, opacity: 1 }, 400)

    if name == 'speaker'
      loadScriptOnce('//speakerdeck.com/assets/embed.js')

    unilytics.page(name)

    #pageElement = doc.getElementsByClassName(name)[0]
    #if pageElement?.className.slice(0, 9) == 'blog-post'
    #  blogPostTitle = pageElement.querySelector('header h2')
    #  disqus.load(pageElement, name, blogPostTitle)

    scrollTo({ y: 0, animate: false })

  isMobileSized = ->
    win.innerWidth <= 760

  setPage = (name = '') ->
    showPageMarkup(name)
    pushState(name)

  onPopState (path = '') ->
    showPageMarkup(path)
  
  
  (name) -> setPage(name)
