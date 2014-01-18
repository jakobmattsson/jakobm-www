toArray = (arrayLike) ->
  for node in arrayLike
    node

memoize = (f) ->
  memory = {}
  (arg) ->
    if !memory[arg]?
      memory[arg] = f(arg)
    memory[arg] = true

pageClassFromUrl = (url) ->
  url.slice(1)

notifyOnChange = (f, delay, callback) ->
  oldValue = f()
  setInterval ->
    newValue = f()
    callback() if newValue != oldValue
    oldValue = newValue
  , delay



analyticsObj = do ->
  if window.location.hostname == 'localhost' then {
    trackLink: ->
    track: (args...) ->
      console.log("Track", args...)
    page: (args...) ->
      console.log("Page", args...)
  } else window.analytics



createHistoryWrapper = (win) ->

  hist = win.history
  loc = win.location

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


# this should be a parameter to the single-page-viewer module
rootPageName = 'home'

makeBodyClassName = (pageName) ->
  'show-' + (pageName || rootPageName)





run = (win) ->
  doc = win.document
  hist = win.history
  loc = win.location

  { pushState, onPopState, getCurrent, init } = createHistoryWrapper(win)

  init()
  doc.body.className = makeBodyClassName(getCurrent())

  loadScript = (url) ->
    node = doc.createElement('script')
    node.setAttribute('type', 'text/javascript')
    node.setAttribute('src', url)
    node.async = true
    doc.body.insertBefore(node)
  
  loadStyles = (url) ->
    node = doc.createElement('link')
    node.setAttribute('rel', 'stylesheet')
    node.setAttribute('type', 'text/css')
    node.setAttribute('href', url)
    doc.body.insertBefore(node)

  loadScriptOnce = memoize(loadScript)

  loadStyles('/.code/transitions.css')

  loadDisqus = do ->
    loaded = false
    (parentNode, disqusIdentifier, disqusTitle) ->

      disqusUrl = 'http://www.jakobmattsson.se/' + disqusIdentifier

      if loaded
        disqusNode = doc.getElementById('disqus_thread')
        parentNode.appendChild(disqusNode)

        DISQUS.reset({
          reload: true
          config: ->
            @page.identifier = disqusIdentifier
            @page.url = disqusUrl
            @page.title = disqusTitle
        })
      else
        disqusNode = doc.createElement('div')
        disqusNode.id = 'disqus_thread'
        parentNode.appendChild(disqusNode)

        win.disqus_shortname = 'jakobm'
        win.disqus_identifier = disqusIdentifier
        win.disqus_title = disqusTitle
        win.disqus_url = disqusUrl

        loadScript('//' + win.disqus_shortname + '.disqus.com/embed.js')
        loaded = true

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
    newClass = makeBodyClassName(name)
    oldClass = doc.body.className
    changed = newClass != oldClass

    doc.body.className = makeBodyClassName(name)

    if changed && name && !isMobileSized()
      $('.' + name).css({ "padding-top": 150, opacity: 0 }).animate({ "padding-top": 130, opacity: 1 }, 400)

    if name == 'speaker'
      loadScriptOnce('//speakerdeck.com/assets/embed.js')

    analyticsObj.page(name)

    #pageElement = doc.getElementsByClassName(name)[0]
    #if pageElement?.className.slice(0, 9) == 'blog-post'
    #  blogPostTitle = pageElement.querySelector('header h2')
    #  loadDisqus(pageElement, name, blogPostTitle)

  isMobileSized = ->
    win.innerWidth <= 760

  showPage = (name = '') ->
    showScrollToTop = isMobileSized() && name != 'home' && name != ''
    toggleScrollButton(showScrollToTop)
    showPageMarkup(name)
    scrollTo({ y: 0, animate: false })

  setPage = (name = '') ->
    showPage(name)
    pushState(name)

  onPopState (path) ->
    showPage(path)

  #win.addEventListener 'scroll', ->
  #  isScrolledDown = getScrollLocation() > getNavHeight() - 10
  #  showScrollToTop = isMobileSized() && isScrolledDown
  #  toggleScrollButton(showScrollToTop)

  #win.addEventListener 'resize', ->
  #  showPage(getCurrent())

  $('.social-links a').each ->
    analyticsObj.trackLink(@, 'Clicked social link', { target: $(@).attr('href') })

  $('.mini-cv a').each ->
    analyticsObj.trackLink(@, 'Clicked employee link', { target: $(@).attr('href') })

  toArray(doc.querySelectorAll('a')).forEach (node) ->
    node.addEventListener 'click', (e) ->
      href = @getAttribute('href')
      return true if href[0] != '/'

      className = node.className

      if className == 'close'
        analyticsObj.track('Clicked close button')
      else if className == 'logo'
        analyticsObj.track('Clicked bowtie button')

      page = pageClassFromUrl(href)
      setPage(page)
      e.preventDefault()
      false

run(window)
