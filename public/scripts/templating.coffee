
# Pages
# ----------------------------------------

pages = [
  { template: 'coder', name: 'Coder', url: '/coder' }
]


# Template rendering
# ----------------------------------------
window.showPage = (url, callback) ->

  # -------------------------------------
  # Helper functions
  # -------------------------------------
  
  highlightMenuItemIfNeeded = (templateName, callback) ->
    # targetMenuItem = $('#navbar ul li a[href="/'+templateName+'"]')
    # if targetMenuItem.hasClass('active')
    #   callback?()
    # else
    #   $('#navbar ul li a').removeClass('active')
    #   targetMenuItem.addClass('active')
    #   setTimeout(callback, 300)
    callback()

  renderCallback = () ->
    

  # -------------------------------------
  # Render given template
  # -------------------------------------

  activePage = pages.filter((page) -> url.split('#')[0] == page.url)[0]

  pages.forEach (page) ->
    page.active = if page == activePage then 'active' else ''

  templateName = if activePage then activePage.template else 'index'

  if document.getElementById('page-content')
    highlightMenuItemIfNeeded templateName, ->
      $('#page-content').fadeOut 300, ->
        dustRender('content-wrapper', templateName, {}, true, renderCallback)
        $('#page-content').fadeIn 300, ->
          analytics?.pageview() # Tell Segment.io to log a pageview
          callback?()
  else
    dustRender('content-wrapper', templateName, {}, true, renderCallback)
    $('#page-content').show 0, ->
      callback?()
  


$(document).ready ->
  # The following variable is set in order to keep track of when the onpopstate event
  # should switch view by calling showPage(). It is set to false when the user navigates
  # to another view from the first view that was loaded. 
  window.firstOnpopstateEvent = true

  url = window.location.pathname
  url = url.substr(0, url.length-1) if url.substr(-1) is "/" # Get rid of trailing '/'
  url = url+window.location.hash # Make sure the url hash tags along if there is one

  if Modernizr.history
    window.history.replaceState({'url':url}, url, url)
  showPage(url)
  # dustRender('nav', 'nav', {pages})



window.dustRender = (id, template, context, append, callback) ->
  source = getTemplate(template)
  dust.loadSource dust.compile(source, template)
  dust.render template, context, (err, out) ->
    if !append
      document.getElementById(id).innerHTML = out
      return

    contentWrapper = document.getElementById(id)
    child = document.getElementById('page-content')
    contentWrapper.removeChild(child) if child

    temp = document.createElement("div")
    temp.innerHTML = out
    contentWrapper.appendChild(temp.children[0])

    callback?()

window.getTemplate = (name) ->
  matches = _(document.getElementsByTagName('script')).toArray().filter (x) ->
    x.getAttribute("data-path") == '/templates/' + name + '.dust';

  throw "No template with that name" if matches.length == 0
  x = matches[0].innerHTML
  



# Provide support for back and forward buttons when window.history is available
# ----------------------------------------------------------------------------------
window.onpopstate = (e) ->
  if Modernizr.history and !window.firstOnpopstateEvent
    # Render new page
    showPage(e.state.url)


