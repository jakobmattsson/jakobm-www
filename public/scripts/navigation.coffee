prevented = (f) ->
  (e) ->
    e.preventDefault()
    f.apply(this, arguments)
    false

pageClassFromUrl = (url) ->
  url.slice(1)





run = (win, doc, hist, loc) ->

  loadScript = (url) ->
    node = document.createElement("script")
    node.setAttribute('type', 'text/javascript')
    node.setAttribute('src', url)
    doc.body.insertBefore(node)
  
  loadScriptOnce = do ->
    loaded = {}
    (url) ->
      return if loaded[url]
      loaded[url] = true
      loadScript(url)

  animatedScrollTo = (y) ->
    $('html, body').animate({ scrollTop: y }, 300)

  toggleScrollButton = (showScrollButton) ->
    $('.scroll-to-top').toggle(showScrollButton)

  getScrollLocation = ->
    $(win).scrollTop()

  getNavHeight = ->
    $('.nav').height()





  showPageMarkup = (name) ->
    newClass = 'show-' + (name || 'home')
    oldClass = doc.body.className
    changed = newClass != oldClass

    doc.body.className = newClass

    if name && changed && oldClass != 'show-home'
      $('.' + name).css({ "padding-top": 150, opacity: 0 }).animate({ "padding-top": 130, opacity: 1 }, 400)

    if name == 'speaker'
      loadScriptOnce('//speakerdeck.com/assets/embed.js')

  interceptClickHandler = (pattern, handler) ->
    nodes = doc.querySelectorAll(pattern)
    for node in nodes
      node.addEventListener('click', prevented(handler))


  isMobileSized = ->
    win.innerWidth <= 760

  showPage = (name = '') ->
    if isMobileSized()
      if !name
        animatedScrollTo(0)
      else
        showPageMarkup(name)
        pageScrollPos = getNavHeight()
        animatedScrollTo(pageScrollPos)
    else
      showPageMarkup(name)
      win.scrollTo(0, 0)

  goToCurrent = ->
    path = loc.pathname
    name = pageClassFromUrl(path)
    showPage(name)

  setPage = (name = '') ->
    showPage(name)
    hist.pushState(null, null, '/' + name)





  win.addEventListener 'popstate', ->
    goToCurrent()

  win.addEventListener 'scroll', ->
    showScrollToTop = isMobileSized() && getScrollLocation() > getNavHeight() - 10
    toggleScrollButton(showScrollToTop)

  win.addEventListener 'resize', ->
    # om denna går från mobil till desktop (eller tvärtom) så ska scrollen uppateras
    path = loc.pathname
    name = pageClassFromUrl(path)
    showPage(name)

  interceptClickHandler 'a.close, .nav a.logo', ->
    setPage()

  interceptClickHandler '.nav p a', ->
    href = @getAttribute('href')
    page = pageClassFromUrl(href)
    setPage(page)

  interceptClickHandler '.scroll-to-top', ->
    setPage()



run(window, window.document, window.history, window.location)
