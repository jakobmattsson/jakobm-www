run = (win, doc, hist) ->

  animatedScrollTo = (y) ->
    $('html, body').animate({ scrollTop: y }, 300)

  toggleScrollButton = (showScrollButton) ->
    $('.scroll-to-top').toggle(showScrollButton)

  getScrollLocation = ->
    $(win).scrollTop()

  getNavHeight = ->
    $('.nav').height()





  showPageMarkup = (name) ->
    doc.body.className = 'show-' + (name || 'start')

  interceptClickHandler = (pattern, handler) ->
    nodes = doc.querySelectorAll(pattern)
    for node in nodes
      node.addEventListener('click', prevented(handler))


  prevented = (f) ->
    (e) ->
      e.preventDefault()
      f.apply(this, arguments)
      false

  pageClassFromUrl = (url) ->
    url.slice(1)

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
    path = location.pathname
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
    path = location.pathname
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



run(window, window.document, window.history)
