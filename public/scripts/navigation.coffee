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

  hasHistoryAPI = hist?

  init = ->
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

  { pushState, onPopState, getCurrent, init }





run = (win) ->
  doc = win.document
  hist = win.history
  loc = win.location

  { pushState, onPopState, getCurrent, init } = createHistoryWrapper(win, loc, hist)

  init()
  win.document.body.className = "show-" + getCurrent()

  loadScript = (url) ->
    node = doc.createElement('script')
    node.setAttribute('type', 'text/javascript')
    node.setAttribute('src', url)
    doc.body.insertBefore(node)
  
  loadStyles = (url) ->
    node = doc.createElement('link')
    node.setAttribute('rel', 'stylesheet')
    node.setAttribute('type', 'text/css')
    node.setAttribute('href', url)
    doc.body.insertBefore(node)

  loadScriptOnce = memoize(loadScript)

  loadStyles('/.code/transitions.css')

  animatedScrollTo = (y) ->
    $('html, body').animate({ scrollTop: y }, 300)

  toggleScrollButton = (showScrollButton) ->
    $('.scroll-to-top').toggle(showScrollButton)

  getScrollLocation = ->
    $(win).scrollTop()

  getNavHeight = ->
    $('.nav').height()


  scrollTo = ({ y, animate }) ->
    if animate
      animatedScrollTo(y)
    else
      win.scrollTo(0, y)



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
      animate = name != getCurrent()
      if !name
        scrollTo({ y: 0, animate })
      else
        showPageMarkup(name)
        pageScrollPos = getNavHeight()
        scrollTo({ y: pageScrollPos, animate })
    else
      showPageMarkup(name)
      scrollTo({ y: 0, animate: false })

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
    showPage(getCurrent(), false)

  interceptClickHandler 'a.close, .nav a.logo', ->
    setPage()

  interceptClickHandler '.nav p a', ->
    href = @getAttribute('href')
    page = pageClassFromUrl(href)
    setPage(page)

  interceptClickHandler '.scroll-to-top', ->
    setPage()



run(window)
