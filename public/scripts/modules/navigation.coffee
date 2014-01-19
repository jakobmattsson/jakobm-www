exports.execute = ({ disqus, tools, loadScript, window, showPage, unilytics }) ->

  {toArray, memoize, notifyOnChange} = tools

  pageClassFromUrl = (url) ->
    url.slice(1)










  win = window
  doc = win.document
  hist = win.history
  loc = win.location

  loadStyles = (url) ->
    node = doc.createElement('link')
    node.setAttribute('rel', 'stylesheet')
    node.setAttribute('type', 'text/css')
    node.setAttribute('href', url)
    doc.body.insertBefore(node)

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







  toArray(doc.querySelectorAll('a')).forEach (node) ->
    node.addEventListener 'click', (e) ->
      href = @getAttribute('href')
      return true if href[0] != '/'

      page = pageClassFromUrl(href)
      showPage(page)
      e.preventDefault()
      false
