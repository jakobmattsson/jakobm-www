exports.dependsOn = ['tools', 'loadScript', 'window', 'showPage', 'unilytics']
exports.execute = ({ tools, loadScript, window, showPage, unilytics }) ->

  {toArray} = tools

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
    doc.body.insertBefore(node, null)

  loadStyles('/.code/transitions.css')

  # Run all internal links as JS, without reloading the page
  toArray(doc.querySelectorAll('a')).forEach (node) ->
    node.addEventListener 'click', (e) ->
      href = @getAttribute('href')
      return true if href[0] != '/'
      page = pageClassFromUrl(href)
      showPage(page)
      e.preventDefault()
      false

  # # Clicks on the navigator (except for links) navigates back to the start page
  # toArray(doc.querySelectorAll('.nav')).forEach (node) ->
  #   node.addEventListener 'click', (e) ->
  #     if (e.target || e.srcElement).tagName != 'A' # .target for standard, .srcElement for IE
  #       showPage('')
