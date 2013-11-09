memoize = (f) ->
  memory = {}
  (arg) ->
    if !memory[arg]?
      memory[arg] = f(arg)
    memory[arg] = true

prevented = (f) ->
  (e) ->
    e.preventDefault()
    f.apply(this, arguments)
    false

pageClassFromUrl = (url) ->
  url.slice(1)

notifyOnChange = (f, delay, callback) ->
  oldValue = f()
  setInterval ->
    newValue = f()
    callback() if newValue != oldValue
    oldValue = newValue
  , delay



createHistoryWrapper = (win, loc, hist) ->

  hasHistoryAPI = false # hist?

  path = pageClassFromUrl(loc.pathname)
  hash = pageClassFromUrl(loc.hash)

  if hasHistoryAPI
    actual = path || hash
    loc.hash = ''
    hist.replaceState(null, null, '/' + actual)
  else
    actual = hash || path
    hist.replaceState(null, null, '/')
    loc.hash = actual
    win.document.body.className = "show-" + actual

  pushState = (name) ->
    if hasHistoryAPI
      hist.pushState(null, null, '/' + name)
    else
      loc.hash = name

  getCurrent = ->
    if hasHistoryAPI
      pageClassFromUrl(loc.pathname)
    else
      pageClassFromUrl(loc.hash)

  onPopState = (f) ->
    if hasHistoryAPI
      win.addEventListener 'popstate', ->
        f(getCurrent())
    else
      notifyOnChange (-> loc.hash), 10, ->
        f(getCurrent())

  { pushState, onPopState, getCurrent }





run = (win, doc, hist, loc) ->

  { pushState, onPopState, getCurrent } = createHistoryWrapper(win, loc, hist)

  loadScript = (url) ->
    node = doc.createElement('script')
    node.setAttribute('type', 'text/javascript')
    node.setAttribute('src', url)
    doc.body.insertBefore(node)

  loadScriptOnce = memoize(loadScript)

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

  setPage = (name = '') ->
    showPage(name)
    pushState(name)

  onPopState (path) ->
    showPage(path)

  win.addEventListener 'scroll', ->
    isScrolledDown = getScrollLocation() > getNavHeight() - 10
    showScrollToTop = isMobileSized() && isScrolledDown
    toggleScrollButton(showScrollToTop)

  win.addEventListener 'resize', ->
    # om denna går från mobil till desktop (eller tvärtom) så ska scrollen uppateras
    showPage(getCurrent())

  interceptClickHandler 'a.close, .nav a.logo', ->
    setPage()

  interceptClickHandler '.nav p a', ->
    href = @getAttribute('href')
    page = pageClassFromUrl(href)
    setPage(page)

  interceptClickHandler '.scroll-to-top', ->
    setPage()



run(window, window.document, window.history, window.location)
